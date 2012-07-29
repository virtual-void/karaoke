# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

module Karaoke
	class App < Sinatra::Base
		configure do
			hash = { "firstname" => "Mark", "lastname" => "Martin", "age" => "24", "gender" => "M" }
			@@array = []
			@@array.push(hash)
			@@array.push(hash)
		end

		get '/' do  
			haml :index  
		end  

		get '/admin' do
			haml :admin	
		end

		get '/update' do
			content_type :json
			@@array.to_json
		end

		post '/apply' do
			#@@my_text = params[:data]
			#haml :index
		end
	end
end
