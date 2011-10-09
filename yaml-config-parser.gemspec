# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'yaml-config-parser'

Gem::Specification.new do |s|
  s.name        = 'yaml-config-parser'
  s.version     = YAMLConfig::VERSION
  s.authors     = ['Mario Fernandez']

  s.homepage    = 'http://github.com/sirech/parse-yaml-config'
  s.summary     = 'Load settings in one or multiple yaml config files'
  s.description = 'Parse a number of yaml config files, building one config object. Multiple keys can be specified to choose which part of the file to load'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency('rspec')
end
