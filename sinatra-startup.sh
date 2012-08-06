#!/bin/sh
export RACK_ENV=production
exec rackup -o 127.0.0.1 -p 9000 1>>/var/log/karaoke-sinatra.log 2>&1 
