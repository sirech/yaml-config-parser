require 'rubygems'
require 'rake'

# Helpers
def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

# Tasks
task :default => :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern   = "spec/**/*_spec.rb"
  t.verbose   = true
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end
