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
			result ||= {}
			unless Table.all.empty?
				tables = Table.all
				tables.each do |t|
					puts t.name
				end
			end
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
				#json = song.attributes.merge({:artist => song.artist.attributes}).to_json
				result = {
					"Result" => "OK",
					"Record" => JSON.parse(person.to_json) #json
				}
			end

			p result.to_json
		end

		post '/UpdateArtist' do
			begin
				person = Artist.get(params[:id])
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
