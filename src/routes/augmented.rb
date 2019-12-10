############################################
# => boards.rb - Augmented Renderer
# => Augmented Blog/News Engine
# => (c) prefetcher & github commiters 2017
#


require 'mysql2'
require 'sanitize'
require 'redcarpet'

module Sinatra
  module Augmented
    module Routing
      module Augmented
        def self.registered(app)
          app.get '/' do
            if not params[:page]
              offset = 0;
            else
              offset = params[:page].to_i * 10;
            end
            erb :aug_index, :locals => {:con => make_con(), :offset => offset}
          end

          app.get '/post' do
            if session[:author].nil? then
              return [403, "You are not an author."]
            else
              erb :aug_post
            end
          end

          app.post '/post' do
            if session[:author].nil? then
              return [403, "You are not an author."]
            else
              con = make_con()

              title = params[:title]
              content = params[:body]
              author = params[:author]
              tag = params[:tag]
              tagline = params[:tagline]
              ip = get_ip(con, request, env);
              attach = ""
              if params[:attach] then attach = params[:attach] end

              query(con, "INSERT INTO posts (title, content, author, ip, is_op, tag, description, attach) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", title, content, author, ip, 1, tag, tagline, attach);

              query(con, "SELECT LAST_INSERT_ID() AS id").each do |res|
                href = "/article/" + res["id"].to_s
                redirect(href, 303);
              end
            end
          end

          app.post '/comment' do
            con = make_con()

            content = params[:body]
            author = params[:author]
            parent = params[:parent]
            ip = get_ip(con, request, env);

            if session[:author] && params[:signed] then
              signed = 1
            else
              signed = 0
            end

            if looks_like_spam(con, ip, env) then
              return [403, "Flood detected, post discarded"]
            end

            query(con, "INSERT INTO posts (content, author, ip, is_op, parent, is_signed_author) VALUES (?, ?, ?, ?, ?, ?)", content, author, ip, 0, parent, signed);
            redirect("/article/" + parent, 303);
          end

          app.get "/article/:id" do |id|
            erb :aug_article, :locals => {:con => make_con(), :id => id, :markdown => Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, strikethrough: true, superscript: true, highlight: true)}
          end

          app.get "/tag/:tag" do |tag|
            erb :aug_tag, :locals => {:con => make_con(), :tag => tag}
          end

          app.get '/author' do
            if session[:author].nil? then
              erb :aug_login
            else
              erb :aug_author
            end
          end

          app.post '/author' do
            Config.get["authors"].each do |author|
              if author["username"] == params[:login] and author["password"] == params[:passwd] then
                session[:author] = author["username"]
                redirect('/author', 303)
              end
            end
            return [403, "Check your username and password"]
          end

          app.get '/logout' do
            if session[:author].nil? then
              redirect('/author', 303)
            else
              session[:author] = nil
              redirect('/author', 303)
            end
          end

          app.get '/feed' do
            erb :aug_feed, :locals => {:con => make_con(), :config => Config.get}
          end
        end
      end
    end
  end
end
