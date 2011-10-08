require 'yaml-config-parser'


describe YAMLConfig do

  before(:each) do
    @parser = YAMLConfig::Parser.new(File.expand_path('../data', __FILE__), :env => ['local', 'development'])
    @files = @parser.find_config_files
  end

  it 'should return an OpenStruct object' do
    @parser.load.should be_a_kind_of OpenStruct
  end

  it 'should find the files to parse' do
    @parser.find_config_files.count.should == 3
  end

  it 'should fail if the main configuration file does not exist' do
    @parser.main = 'doesnt_exist'
    lambda { @parser.find_config_files }.should raise_error ArgumentError
  end

  it 'should put the main file first' do
    @parser.find_config_files.first.should satisfy {|f| f.include? 'config.yml' }
  end

  it 'should be able to deal with a single environment' do
    @parser.environment = 'local'
    @parser.environment.should == ['local']
  end

  it 'should convert a yml to a hash, using the environments to choose the part of the yml to take' do
    @parser.send(:file_to_hash, @files.first).should == {"is_global"=>true}
  end

  it 'should fail when trying to use an environment that is not present in the yml file' do
    @parser.environment = 'NO'
    lambda { @parser.send(:file_to_hash, @files.first)}.should raise_error ArgumentError
  end

  it 'should fail when trying to use the same key twice for the hash' do
    lambda { @parser.send(:add_to_hash, { 'a' => 1}, 'a', {})}.should raise_error ArgumentError
  end

  it 'should merge all configuration files to one hash' do
    @parser.send(:merge_config_files).keys.should == ['is_global', 'db', 'logging']
  end

  it 'should produce a valid OpenStruct object with all the data from the config files' do
    cfg = @parser.load
    cfg.is_global.should == true
    cfg.db.should == {"database"=>"db", "port"=>27017, "host"=>"localhost"}
    cfg.logging.should == {"is_global"=>true, "level"=>"DEBUG"}
  end
end
