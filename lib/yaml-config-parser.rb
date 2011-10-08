require 'yaml'
require 'ostruct'

module YAMLConfig
  VERSION = '0.1.1'

  class Parser

    attr_reader :environment
    attr_accessor :path, :main, :extra

    def initialize(path, args = {})
      @path = path
      @main = args[:main] || 'config.yml'
      @extra = args[:extra] || 'config.*.yml'
      self.environment = args[:env] || 'development'
    end

    def load
      OpenStruct.new({})
    end

    def environment=(env)
      if env.class == String
        env = [env]
      end
      @environment = env
    end

    # Get the path for all the configuration files. The main file is
    # put first
    def find_config_files
      main = File.join(@path, @main)
      raise ArgumentError.new("Main config file #{main} does not exist") unless File.exists? main
      extra = Dir.glob(File.join(@path, @extra))
      ([main] + extra).uniq
    end

    private

    def file_to_hash file_name
      h = YAML.load_file file_name
      @environment.each do |env|
        h = h[env]
        raise ArgumentError.new("Environment #{env} does not exist in the file. Are you sure the order of the environments is correct?") if h.nil?
      end
      h
    end
  end
end
