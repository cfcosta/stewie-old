require 'yaml'
require 'forwardable'

class ConfigParser
  extend Forwardable
  def_delegators :@options, :to_module

  def initialize(file = 'config.yml')
    @options = YAML.load_file(file)
  end
end
