############################################
# => config.rb - Config singleton
# => Augmented
# => (c) prefetcher & github commiters 2019
#

require 'json'
require 'singleton'
class Config
  include Singleton
  attr_accessor :obj

  def self.get
    instance.obj
  end
  def initialize
    config_raw = File.read('aug_config.json')
    @obj = JSON.parse(config_raw)
  end
  def self.rewrite!
    File.open("aug_config.json", "w") do |f|
      f.write(JSON.pretty_generate(Config.get))
    end
  end
end