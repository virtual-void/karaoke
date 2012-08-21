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

		get '/view' do
			haml :view
		end

		get '/update' do
			content_type :json
			persons = Artist.all
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
				if params[:jtSorting]
					sort_criteria = params[:jtSorting]
					if sort_criteria == 'status DESC'
						persons = Artist.all(:order => [ :status.desc ])
					else
						persons = Artist.all(:order => [ :status.asc])
					end
				else
					persons = Artist.all()
				end
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
				song = Song.new(:name => params[:song_name])
				person.song = song

				person.table = Table.get(params[:table_id])
				person.save
			rescue Exception => e
				result = {
					"Result" => "Error", "Message" => e.message
				}
			else
				json = JSON.parse(person.to_json(:methods => [:song_name]))
				result = {
					"Result" => "OK",
					"Record" => JSON.parse(json.to_json)
				}
			end
			p result.to_json
		end

		post '/UpdateArtist' do
			begin
				person = Artist.get(params[:id])
				song = person.song
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
				person.song.destroy
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
