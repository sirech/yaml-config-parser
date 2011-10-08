require 'yaml-config-parser'


describe YAMLConfig do

  before(:each) do
    @parser = YAMLConfig::Parser.new(File.expand_path('../data', __FILE__), ['local', 'development'])
  end

  it 'should return an OpenStruct object' do
    @parser.load.should be_a_kind_of OpenStruct
  end

  it 'should find the files to parse' do
    @parser.send(:find_config_files).count.should == 3
  end

  it 'should be able to deal with a single environment' do
    @parser.environment = 'local'
    @parser.environment.should == ['local']
  end
end
