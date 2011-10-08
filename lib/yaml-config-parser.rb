require 'yaml'
require 'ostruct'

module YAMLConfig
  VERSION = '0.1.1'

  class Parser

    def initialize(path)
      @path = path
      @pattern = '*.yml'
    end

    def load
      OpenStruct.new({})
    end

    private

    def find_config_files
      Dir.glob(File.join(@path, @pattern))
    end
  end
end
