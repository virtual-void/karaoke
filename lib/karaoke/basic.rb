require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

module Karaoke
	class App < Sinatra::Base
		#PErforms configuration and initialization steps
		configure do
			@array ||= []
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

		get '/update' do
			content_type :json
			#@@array.sort_by{|f| f["id"]}.to_json
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
