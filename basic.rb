require 'rubygems'
require 'sinatra'
require 'haml'

module Karaoke
	class App < Sinatra::Base
		configure do
			@@my_text = "Hrld"
		end
		

		get '/' do  
			haml :index  
		end  

		get '/admin' do
			haml :admin	
		end

		get '/update' do
			@@my_text
		end

		post '/apply' do
			@@my_text = params[:data]
		#haml :index
		end
	end
end
