require 'yaml'

class ConfigParser
  def initialize(file = 'config.yml')
    @options = YAML.load_file(file)
  end

  def options
    @options
  end
end
