require "spec_helper"

describe Karaoke do

	it "should insert a Table to DB" do
		Karaoke::Table.new(:name=>"Table1").save	
	end

	it "should insert an Artist to DB" do
		person = Karaoke::Artist.new
		person.status = :vip

		person.song = Karaoke::Song.new(:name => 'Artist_song')
		person.table = Karaoke::Table.new(:name=>"Artist_table")

		person.save
		
	end

	it "should return ALL data from all tables" do
		persons = Karaoke::Artist.all
		result_ = []

		persons.each do |p|
		 	#song = p.song #get first song
		 	#result_ << song.attributes.merge(p.attributes)
		 	puts "JSON: #{p.to_json(:methods => [:song_name, :table_name],:only => [:status, :song_name, :table_name])}"
		 end
		# #puts "JSON_VIEW #{result_.to_json}"
		# json = 	JSON.parse(result_.to_json.gsub('name','song_name'))
		# puts "JSON_VIEW #{json.to_json}"
	end

	it "should return all Tables from DB" do
		#puts "TABLE COUNT: #{Karaoke::Table.all.count}"
	end

	it "should return all Artists from DB" do
		#puts "ARTISTS COUNT: #{Karaoke::Artist.all.count}"
		persons = Karaoke::Artist.all()
		result_ = []

		persons.each do |p|
			song = p.song #get first song
			#puts "SONG: #{song.attributes.merge(p.attributes).to_json(:only => [:name])}"
			result_ << song.attributes.merge(p.attributes)
		end
		
		#puts "JSON::: #{result_.to_json}"
	end

end
