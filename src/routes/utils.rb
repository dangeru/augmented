############################################
# => utils.rb - Various utilities
# => Augmented
# => (c) prefetcher & github commiters 2019
#

def make_con()
  return Mysql2::Client.new(:host => "localhost", :username => "augmented", :password => "augmented", :database => "augmented")
end

def query(con, stmt, *args)
  return con.prepare(stmt).execute(*args)
end

def get_ip(con, request, env)
  ip = request.ip
  if ip == "127.0.0.1"
    ip = env["HTTP_X_FORWARDED_FOR"]
  end
  return ip
end

def looks_like_spam(con, ip, env)
  # if the user has never posted, the block in con.query.each won't be run, so by default it's not spam
  result = false
  query(con, "SELECT COUNT(*) AS count FROM posts WHERE ip = ? AND UNIX_TIMESTAMP(date_posted) > ?", ip, Time.new.strftime('%s').to_i - 30).each do |res|
    if res["count"] >= 4 then
      result = true
    else
      result = false
    end
  end
  return result
end