require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

module Karaoke
	class App < Sinatra::Base
		#PErforms configuration and initialization steps
		configure do
			#@@personMap ||= []
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

		get '/update' do
			content_type :json
			persons = Artist.all
			result_ = []

			persons.each do |p|
				song = p.songs[0] #get first song
				#puts "SONG: #{song.attributes.merge(p.attributes).to_json(:only => [:name])}"
				result_ << song.attributes.merge(p.attributes)
			end
			#puts "JSON_VIEW #{result_.to_json}"
			json = 	JSON.parse(result_.to_json.gsub('name','song_name'))
			puts "JSON_VIEW #{json.to_json}"
			json.to_json
		end

		get '/view' do
			haml :view
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

		post '/ArtistList' do
			if Artist.all.empty?
				result = {
					"Result" => "OK", "Records" => ''
				}
			else
				persons = Artist.all
				result_ = []

				persons.each do |p|
					song = p.songs[0] #get first song
					#puts "SONG: #{song.attributes.merge(p.attributes).to_json(:only => [:name])}"
					result_ << song.attributes.merge(p.attributes)
				end
				
				puts "JSON::: #{result_.to_json}"

				result = {
					"Result" => "OK", "Records" => JSON.parse(result_.to_json.gsub('name','song_name'))
				}
			end
			p result.to_json
		end

		post '/CreateArtist' do
			begin
				person = Artist.new
				person.status = params[:status]

				song = Song.new
				song.name = params[:song_name]
				person.table = Table.get(params[:table_id])
				person.songs << song

				person.save
			rescue Exception => e
				result = {
					"Result" => "Error", "Message" => e.message
				}
			else
				json = song.attributes.merge(song.artist.attributes).to_json(:only => [:name])
				result = {
					"Result" => "OK",
					"Record" => JSON.parse(json.gsub('name','song_name'))
				}
			end

			p result.to_json
		end

		post '/UpdateArtist' do
			begin
				person = Artist.get(params[:id])

				song = person.songs[0]

				song.update(:name => params[:song_name])
				person.update(:status => params[:status])
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
				#delete all songs belong to an artist
				person.songs.each do |s|
					s.destroy
				end

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
	end
end
