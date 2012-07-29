# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

module Karaoke
	class App < Sinatra::Base
		configure do
			@@array ||= []
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
			id = params[:id]
			table = params[:table]
			track = params[:track]
			
			hash_data ||= {}

			hash_data = {
			 	"id" => id,
			 	"table" => table,
			 	"track" => track
			 }
			 @@array << hash_data
			 haml :admin
		end
	end
end
