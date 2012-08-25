require "rubygems"
require 'sinatra'

require 'rspec'
require 'rspec/autorun'
require 'test/unit'
require 'rack/test'

$:.unshift( '.' )
$:.unshift( File.dirname(__FILE__) + '../lib' )

require 'karaoke/data_model'
require 'websocket'
require 'karaoke/app'

set :environment, :test

def app
	@app = Karaoke::App.new
end

# set test environment
Karaoke::App.set :run, false
Karaoke::App.set :raise_errors, true
Karaoke::App.set :logging, false
