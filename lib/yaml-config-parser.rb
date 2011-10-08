require 'yaml'
require 'ostruct'

module YAMLConfig
  VERSION = '0.1.1'

  class Parser

    attr_reader :path, :pattern, :environment
    
    def initialize(path, env)
      @path = path
      @pattern = '*.yml'
      environment = env
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

    private

    def find_config_files
      Dir.glob(File.join(@path, @pattern))
    end
  end
end
