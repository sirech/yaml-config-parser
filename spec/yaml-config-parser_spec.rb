require 'yaml-config-parser'


describe YAMLConfig do

  before(:each) do
    @parser = YAMLConfig::Parser.new
  end

  it 'should return an OpenStruct object' do
    @parser.load.should be_a_kind_of OpenStruct
  end
end
