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
			puts @@array
			content_type :json
			@@array.sort_by{|f| f["id"]}.to_json
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

 			hash_item =  @@array.find{|f| f["id"].eql?(id)}
			
			unless hash_item 
				puts "Added to array"
				@@array << hash_data
			else
				hash_item["table"] = table
				hash_item["track"] = track
			end

			puts @@array

			redirect :admin
		end
	end
end
