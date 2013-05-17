require 'rspec'
require File.dirname(__FILE__) + '/../lib/cologger'

describe "Cologger Spec"  do

	before :each do
		@logger = Cologger.new
		@fatal = @logger.fatal "FATAL msg should be red"
		
	end
	
	
	it "Fatal msssage should has keyword FATAL" do
	
		@fatal.downcase.include?("fatal").should == true

	end





	
end
