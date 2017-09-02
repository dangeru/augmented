############################################
# => boards.rb - Augmented Renderer
# => Awoo Textboard Engine
# => (c) prefetcher & github commiters 2017
#


#require 'mysql2'

module Sinatra
  module Augmented
    module Routing
      module Augmented
        def self.registered(app)
          app.get '/' do
            erb :aug_index
          end
        end
      end
    end
  end
end
