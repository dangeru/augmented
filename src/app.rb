############################################
# => app.rb - Main Renderer
# => Augmented
# => (c) prefetcher & github commiters 2017
#

require 'sinatra/base'
require 'json'

require_relative 'routes/augmented'

class Augmented < Sinatra::Base
  register Sinatra::Augmented::Routing::Augmented
  configure do
    set :bind, '0.0.0.0'
    set :augmented_version, '0.0.1'
    set :public_folder, File.dirname(__FILE__) + '/static'
  end

  set :root, File.dirname(__FILE__)
  enable :sessions
end
