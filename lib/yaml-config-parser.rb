require 'yaml'
require 'ostruct'

module YAMLConfig
  VERSION = '0.1.1'

  class Parser

    attr_reader :path, :pattern, :environment

    def initialize(path, environment)
      @path = path
      @pattern = '*.yml'
      self.environment = environment
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

    def find_config_files
      Dir.glob(File.join(@path, @pattern))
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
