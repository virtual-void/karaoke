# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

module Karaoke
	class App < Sinatra::Base
		configure do
			hash = { "id" => "99", "table" => "Martin", "track" => "Lacrimosa - Seele im Not"}
			@@array = []
			@@array.push(hash)
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
