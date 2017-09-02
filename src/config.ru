############################################
# => config.ru - Rackup config file
# => Augmented
# => (c) prefetcher & github commiters 2017
#

require File.dirname(__FILE__) + '/app'

puts "Augmented is starting..."
Augmented.run!
