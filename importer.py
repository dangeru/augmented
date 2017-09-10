import glob, html, datetime, pymysql
con = pymysql.connect("localhost", "awoo", "awoo", "awoo")
def date(d):
    d = d.split(" ")
    formatted = d[0] + " " + d[2]
    return int(datetime.datetime.strptime(formatted, "%m/%d/%y %H:%M:%S").strftime("%s"))
def make_datetime(d):
    return "TIMESTAMP('" + datetime.datetime.fromtimestamp(d).strftime("%Y-%m-%d %H:%M:%S") + "')"
out = open("output.sql", "w")
out.write("USE augmented;\n")
out.write("DELETE FROM posts;\n")
out.write("CREATE TEMPORARY TABLE x (id INTEGER);\n")
for f in glob.glob("post/*.txt"):
    op = open(f, "r").read().split("\n")
    title = html.unescape(op[0][3:])
    author = op[1].split("\"")[1]
    contents = html.unescape("\n".join(op[2:]))
    replies = open(f.replace("post", "comments"), "r").read().split("\n")
    rs = []
    r = ""
    meta = []
    for line in replies:
        if len(line) == 0: continue
        if line[0] == "[":
            if r != "": rs.append([*meta, html.unescape(r)])
            r = ""
            meta = line.split("\"")
            # [:-2] to strip off the trailing ", "
            meta = [meta[1][:-2], date(meta[3])]
        else:
            r += line + "\n"
    if r != "": rs.append([*meta, r])
    out.write("DELETE FROM x;\n")
    out.write("INSERT INTO posts (title, content, author, date_posted) VALUES (" + con.escape(title) + ", "+con.escape(contents)+", "+con.escape(author)+", "+(make_datetime(rs[0][1]) if len(rs) > 0 else "CURRENT_TIMESTAMP()")+");\n")
    out.write("INSERT INTO x (id) VALUES (LAST_INSERT_ID());\n")
    for comment in rs:
        out.write("INSERT INTO posts (description, author, parent, date_posted) VALUES ("+con.escape(comment[2])+", "+con.escape(comment[0])+", (SELECT id FROM x), "+make_datetime(comment[1])+");\n")
out.write("DROP TABLE x;\n")
out.close()
