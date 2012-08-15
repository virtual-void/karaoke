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

set :environment, :development

# Include the Rack test methods to Test::Unit
#Test::Unit::TestCase.send :include, Rack::Test::Methods

# Add an app method for RSpec
def app
  Sinatra::Application
end

Rspec.configure do |config|
  # config.before(:each) { DataMapper.auto_migrate! }
  config.include Rack::Test::Methods
end
