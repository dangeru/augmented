############################################
# => app.rb - Main Renderer
# => Augmented
# => (c) prefetcher & github commiters 2017
#

require 'sinatra/base'

require_relative 'routes/augmented'
require_relative 'routes/config'
require_relative 'routes/utils'

class Augmented < Sinatra::Base
  register Sinatra::Augmented::Routing::Augmented
  configure do
    set :bind, Config.get['bind']
    set :port, Config.get['port']
    set :augmented_version, '1.0.0'
    set :public_folder, File.dirname(__FILE__) + '/static'
  end

  set :root, File.dirname(__FILE__)
  enable :sessions
end
