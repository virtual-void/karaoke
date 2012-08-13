require 'rubygems'
require 'bundler'
require 'dm-core'
require 'dm-migrations'

require 'rspec/core/rake_task'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end


RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc  "Run all specs with simplecov"
RSpec::Core::RakeTask.new(:coverage) do |t|
  ENV['COVERAGE'] = "true"
end

desc 'Migrate DataMapper database'
task :migrate do
  DataMapper.auto_migrate!
end
