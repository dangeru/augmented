############################################
# => boards.rb - Augmented Renderer
# => Awoo Textboard Engine
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

module Sinatra
  module Augmented
    module Routing
      module Augmented
        def self.registered(app)
          app.get '/' do
            erb :aug_index
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
        end
      end
    end
  end
end
