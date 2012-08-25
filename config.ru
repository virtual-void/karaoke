Encoding.default_internal = "UTF-8"
Encoding.default_external = "UTF-8"

$:.unshift( './lib')

require 'karaoke/app'
require 'karaoke/data_model'
require 'rack'
require 'sinatra'

set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)

## CONFIGURATION
configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/#{Sinatra::Application.environment}.sqlite")  
  DataMapper::Logger.new(STDOUT, :debug)
  DataMapper.finalize
	# # Automatically create the tables if they don't exist
  DataMapper.auto_upgrade! #auto_migrate
end

run Karaoke::App
