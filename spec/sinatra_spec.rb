require "spec_helper"

describe 'App' do
	include Rack::Test::Methods

	  describe '/' do
    	it 'should respond to /' do
      		get '/'
      		last_response.status.should == 200
    	end

    	it 'should respond to /view' do
      		get '/view'
      		last_response.status.should == 200
    	end

  	  end
end
