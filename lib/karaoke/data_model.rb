require 'dm-core'
require 'dm-types'
require 'dm-migrations'
require 'dm-serializer'

# Open the database karaoke.db
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/db/#{Sinatra::Application.environment}.sqlite" )

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
	DataMapper.auto_upgrade! #auto_migrate
end
