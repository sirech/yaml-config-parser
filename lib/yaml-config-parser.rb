require 'yaml'
require 'ostruct'

module YAMLConfig
  VERSION = '0.1.3'

  class Parser

    attr_reader :environment
    attr_accessor :path, :main, :extra

    # Instantiate a new configuration parser.
    #
    # path - The directory where the configuration files are stored
    # :env - (optional) The list of environments used to choose the
    #        right keys. If there is only one environment it can be passed as
    #        a String. Default is 'development'
    def initialize(path, args = {})
      @path = path
      # TODO: make main and extra files configurable
      @main = 'config.yml'
      @extra = 'config.*.yml'
      self.environment = args[:env] || 'development'
    end

    # Loads all the config files that can be found under the
    # given path, chooses the right environments, and merges them
    # into a new OpenStruct object
    #
    # Returns an OpenStruct with the configuration keys
    def load
      OpenStruct.new merge_config_files
    end

    def environment=(env)
      if env.class == String
        env = [env]
      end
      @environment = env
    end

    # Gets the path for all the configuration files. The main file is
    # put first
    #
    # Returns an Array of Strings, each one being a path to a
    # configuration file.
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

    def choose_key_for_extra_file file_name
      file_name.gsub(/.yml$/, '').split('.')[-1]
    end

    def add_to_hash(hash, key, extra)
      hash.merge!({key => extra}) do |key,_,_|
        raise ArgumentError.new("The key #{key} is duplicated")
      end
    end

    def merge_config_files
      files = find_config_files
      h = file_to_hash(files.shift)
      files.each do |file_name|
        add_to_hash(h, choose_key_for_extra_file(file_name), file_to_hash(file_name))
      end
      h
    end
  end
end
