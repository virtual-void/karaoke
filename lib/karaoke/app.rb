require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require "eventmachine"
require 'sinatra/streaming'

module Karaoke
	class App < Sinatra::Base
		#Performs configuration and initialization steps
		configure do
			#Array of SSE connections for live-updating
			set :connections, Array.new
			set :server, 'thin'
		end

		get '/' do  
			haml :index  
		end  

		get '/tables' do
			haml :tables	
		end

		get '/artists' do
			haml :artists	
		end

		get '/view' do
			haml :view
		end

		get '/stream', provides: 'text/event-stream' do
		  stream :keep_open do |out|
		  	settings.connections << out
		  	puts "Connection opened\n"
		    out.callback { puts 'Connection closed\n'; settings.connections.delete(out) } # modified

		    # EventMachine::PeriodicTimer.new(2) { 
			   #  settings.connections.each { |out| out << "data: Hello!!\n\n" }			    
			   #  puts "Data sent to client"
		    # } # added
		  end
		end

		get '/update' do
			content_type :json
			persons = Artist.all(:order => [ :status.asc ], :limit => 10)
			result_ = []

			persons.each do |p|
				result_ << JSON.parse(
					p.to_json(
						:methods => [:song_name, :table_name],
						:only => [:id, :status, :song_name, :table_name]
						)
					)
			end

			json = 	JSON.parse(result_.to_json)
			json.to_json
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

		post '/UpdateTable' do
			begin
				table = Table.get(params[:id])
				table.update(:name => params[:name])
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

		post '/DeleteTable' do
			begin
				table = Table.get(params[:id])
				table.artists.destroy
				table.destroy

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

		post '/GetTableOptions' do
			tables = Table.all()

			result = { "Result" => "OK", "Options" => JSON.parse(tables.to_json.gsub('id', 'Value').gsub('name', 'DisplayText')) }
			
			p result.to_json
		end

		#Return all song names from DB
		post '/SongList' do
			songs = Song.all(:name.like => '%' + params[:term] + '%' )
			result_ = []
			songs.each do |s|
			 	result_ << s.name #JSON.parse(s.to_json( :only => [:name] ))
			end
			p result_.to_json
		end

		post '/ArtistList' do
				persons = Artist.all(:order => [ :status.asc ])
				if persons.empty?
					result = {
					"Result" => "OK", "Records" => ''
					}
				else
					result_ = []
					persons.each do |p|
						result_ << JSON.parse(p.to_json(:methods => [:song_name]))
					end

					result = {
						"Result" => "OK", "Records" => JSON.parse(result_.to_json)
					}
				end

				p result.to_json
		end

		post '/CreateArtist' do
			begin
				person = Artist.new(:status => params[:status])
				song = Song.first(:name => params[:song_name])
				
				if song.nil?
					song = Song.new(:name => params[:song_name])
				end

				person.song = song

				person.table = Table.get(params[:table_id])
				person.save
			rescue Exception => e
				result = {
					"Result" => "Error", "Message" => e.message
				}
			else
				json = JSON.parse(person.to_json(:methods => [:song_name, :table_name]))
				result = {
					"Result" => "OK",
					"Record" => JSON.parse(json.to_json)
				}
			end

			settings.connections.each { |out| 
				view_result = {
					:command => "created",
					:record => JSON.parse(json.to_json)
				}
				out << "event:create\r\ndata: #{view_result.to_json}\n\n" 
			}

			p result.to_json
		end

		post '/UpdateArtist' do
			begin
				person = Artist.get(params[:id])
				song = Song.first(:name => params[:song_name])

				if song.nil?
					song = Song.new(:name => params[:song_name])
					song.save
				end

				person.update(:status => params[:status], :table_id => params[:table_id], :song_id => song.id)
			rescue Exception => e
				result = {
					"Result" => "Error", "Message" => e.message
				}
			else
				result = {
					"Result" => "OK"
				}
			end

			settings.connections.each { |out| 
				json = JSON.parse(person.to_json(:methods => [:song_name, :table_name]))

				view_result = {
					:command => "updated",
					:record => JSON.parse(json.to_json)
				}

				out << "event:update\r\ndata: #{view_result.to_json}\n\n" 
			}

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

			settings.connections.each { |out| 
				json = JSON.parse(person.to_json(:methods => [:song_name, :table_name]))

				view_result = {
					:command => "deleted",
					:record => JSON.parse(json.to_json)
				}
				
				out << "event:delete\r\ndata: #{view_result.to_json}\n\n" 
			}

			p result.to_json
		end
	end
end
