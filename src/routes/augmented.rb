############################################
# => boards.rb - Augmented Renderer
# => Augmented Blog/News Engine
# => (c) prefetcher & github commiters 2017
#


require 'mysql2'
require 'sanitize'

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

module Sinatra
  module Augmented
    module Routing
      module Augmented
        def self.registered(app)
          app.get '/' do
            erb :aug_index, :locals => {:con => make_con()}
          end

          app.get '/post' do
            erb :aug_post
          end

          app.post '/post' do
            con = make_con()

            title = params[:title]
            content = params[:body]
            author = params[:author]
            tag = params[:tag]
            ip = get_ip(con, request, env);

            query(con, "INSERT INTO posts (title, content, author, ip, is_op, tag) VALUES (?, ?, ?, ?, ?, ?)", title, content, author, ip, 1, tag);

            query(con, "SELECT LAST_INSERT_ID() AS id").each do |res|
              href = "/article/" + res["id"].to_s
              redirect(href, 303);
            end
          end

          app.post '/comment' do
            con = make_con()

            content = params[:body]
            author = params[:author]
            parent = params[:parent]
            ip = get_ip(con, request, env);

            if looks_like_spam(con, ip, env) then
              return [403, "Flood detected, post discarded"]
            end

            query(con, "INSERT INTO posts (content, author, ip, is_op, parent) VALUES (?, ?, ?, ?, ?)", content, author, ip, 0, parent);
            redirect("/article/" + parent, 303);
          end

          app.get "/article/:id" do |id|
            erb :aug_article, :locals => {:con => make_con(), :id => id}
          end

          app.get "/tag/:tag" do |tag|
            erb :aug_tag, :locals => {:con => make_con(), :tag => tag}
          end
        end
      end
    end
  end
end
