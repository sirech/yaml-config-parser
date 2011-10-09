# YAML Config Parser

This gem allows to parse multiple YAML configuration files into one
Config object. It attempts to solve two different problems:

* Having multiple environments types. For example, you might want to
  parse the config choosing between the common __development__,
  __test__ and __production__ envs. But sometimes that is not
  enough. If you want to have different settings for your _local_
  machine and your _integration_ one, and each of them can run in
  more than one mode, using just one selector doesn't solve it. For
  that reason, this gem allows to use a hierarchy, so that you can
  choose something like _local_ > __development__.
  
* For many projects, the configuration settings can get very big, and
  thus you might want multiple configuration files, with the
  convenience of having only one object with all the settings,
  separated in namespaces (like 'db' or 'logging'). This gem uses one
  main file, where the usual settings are saved, but also other
  configuration files can be used.

## Usage

The Parser is created by passing a path and a list of environments,
like this:

    YAMLConfig::Parser.new(File.expand_path('../config', __FILE__), :env => ['local', 'development'])

The first argument is a path to a directory. It is expected to contain
a main settings file, _config.yml_, and optionally multiple extra
settings file, in the form of _config.*.yml_. Valid files would be
_config.db.yml_ or _config.logging.yml_.

The second argument defines the environments used to select the
contents of the configuration files. For the given example, each
configuration file is expected to contain a _local_ key, which should
contain a _development_ key inside it as well.

The settings of the main file are taken without change. For the extra
files, a hash with the name of the file (_logging_ for
_config.logging.yml_) is built with all the settings, and this hash is
put in the result file.

## Example

If the given directory contains a _config.yml_ file like:

    local:
        development:
            key1 : true
    
        test:
            key1 : false

    integration:
        production:
            key2 : 3
            
and a _config.logging.yml_ file like:            

    local:
        development:
            level : DEBUG
    
        test:
            level : WARN

    integration:
        production:
            active : false
            
The result of calling the __load__ method would create an
__OpenStruct__ object equivalent to the following hash:

    {
        'key1' => true,
        'logging' => { 'level' => 'DEBUG' }
    }
