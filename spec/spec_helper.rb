require "rubygems"
require 'sinatra'

require 'rspec'
require 'rspec/autorun'
require 'test/unit'
require 'rack/test'

$:.unshift( '.' )
$:.unshift( File.dirname(__FILE__) + '../lib' )

require 'karaoke/data_model'
require 'karaoke/basic'

set :environment, :test

# Include the Rack test methods to Test::Unit
#Test::Unit::TestCase.send :include, Rack::Test::Methods

def app
	@app = Karaoke::App.new
end

# set test environment
Karaoke::App.set :run, false
Karaoke::App.set :raise_errors, true
Karaoke::App.set :logging, false
