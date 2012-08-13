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
    	property :record_date, 	DateTime,  	:default => Time.now

		#belongs_to :song
		belongs_to :table
	end
  
  	class Song
   		include DataMapper::Resource
 
		property :id,     	Serial
		property :name, 	String,  	:required => true
		property :rating, 	Integer
		 
		#has n, :artists  # defaults to :required => true
		 
		def self.popular
			all(:rating.gt => 3)
		end
	end

	class Table
		include DataMapper::Resource

		property :id,     	Serial
		property :name, 	String,  	:required => true

		has n, :artists  # defaults to :required => true
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

		get '/test' do
			haml :test	
		end

		get '/artists' do
			haml :artists	
		end

		get '/admin' do
			haml :admin	
		end

		post '/TableList' do
			if Table.all.empty?
				result = { "Result" => "OK" }
			else
				result = { "Result" => "OK", "Records" => JSON.parse(Table.all.to_json) }
			end
			p result.to_json
		end

		post '/CreateTable' do
			begin
				table = Table.new
				table.name = params[:name]
				table.save

			rescue Exception => e
				result = {
					"Result" => "Error", "Message" => e.message
				}
			else
				result = {
					"Result" => "OK",
					"Record" => JSON.parse(table.to_json)
				}
			end

			p result.to_json
		end

		post '/GetTableOptions' do
			tables = Table.all()

			result = { "Result" => "OK", "Options" => JSON.parse(tables.to_json.gsub('id', 'Value').gsub('name', 'DisplayText')) }
			
			p result.to_json
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
				person.table = Table.get(params[:table_id])
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
