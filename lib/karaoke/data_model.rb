require 'dm-core'
require 'dm-types'
require 'dm-migrations'
require 'dm-serializer'

#Just for logging only
#DataMapper::Logger.new(STDOUT, :debug)
# Open the database karaoke.db
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/db/#{Sinatra::Application.environment}.sqlite" )

module Karaoke
	class Artist
		include DataMapper::Resource
	 
	    property :id, 			Serial
	    property :status, 		Enum[ :regular, :paid, :vip, :outofturn ], :default => :regular
    	property :record_date, 	DateTime,  	:default => Time.now
		#belongs_to :song
		belongs_to :table
		belongs_to :song
		# has n, :songs
	end
  
 	class Song
  		include DataMapper::Resource
 
		property :id,     	Serial
		property :name, 	String,  	:required => true
		has n, :artists
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
