# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'dm-core'
require 'dm-types'
require 'dm-migrations'
require 'dm-serializer'

# Open the database karaoke.db
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/db/karaoke.db" )

module Karaoke
	class Artist
		include DataMapper::Resource
	 
	    property :id, 			Serial
	    property :status, 		Enum[ :new, :open, :closed, :invalid ], :default => :new
	    property :name, 		String,  	:required => true
    	property :record_date, 	DateTime,  	:default => Time.now

    	has 1, :song
    	has 1, :table
	end
  
  	class Song
   		include DataMapper::Resource
 
		property :id,     	Serial
		property :name, 	String,  	:required => true
		property :rating, 	Integer
		 
		belongs_to :artist  # defaults to :required => true
		 
		def self.popular
			all(:rating.gt => 3)
		end
	end

	class Table
		include DataMapper::Resource

		property :id,     	Serial
		property :name, 	String,  	:required => true

		belongs_to :artist  # defaults to :required => true
	end

	DataMapper.finalize
	# Automatically create the tables if they don't exist
	DataMapper.auto_migrate!

	class App < Sinatra::Base
		configure do
			#@@array ||= []
			#@@personMap ||= []
		end

		get '/' do  
			haml :index  
		end  

		get '/admin' do
			haml :admin	
		end

		post '/ArtistList' do
			if Artist.all.empty?
				result = {
					"Result" => "OK", "Records" => ''
				}
			else
				result = {
					"Result" => "OK", "Records" => JSON.parse(Artist.all.to_json)
				}
			end
			p result.to_json
		end

		post '/CreateArtist' do
			begin
				person = Artist.new
				person.status = params[:status]
				person.name = params[:name]
				person.save

			rescue Exception => e
				result = {
					"Result" => "Error", "Message" => e.message
				}
			else
				result = {
					"Result" => "OK",
					"Record" => JSON.parse(person.to_json)
				}
			end

			p result.to_json
		end

		post '/UpdateArtist' do
			begin
				person = Artist.get(params[:id])
				person.update(:status => params[:status], :name => params[:name])
			
			rescue Exception => e
				result = {
					"Result" => "Error", "Message" => e.message
				}
			else
				result = {
					"Result" => "OK"
				}
			end

			p result.to_json
		end

		post '/DeleteArtist' do
			begin
				person = Artist.get(params[:id])
				person.destroy

			rescue Exception => e
				result = {
					"Result" => "Error", "Message" => e.message
				}
			else
				result = {
					"Result" => "OK"
				}
			end

			p result.to_json
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
