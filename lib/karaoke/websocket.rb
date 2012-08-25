require "rubygems"
require "eventmachine"
require "em-websocket"
require "json"

require "pp"

module Karaoke
  class WebSocket
    EventMachine.run do
      @sockets = []
      @clients = Array.new

      def test_m
        puts "Called method"
      end
      
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |socket|
       puts "Started"
       socket.onopen do
        puts "===> Client connected"
      end

      socket.onmessage do |message|
        @clients ||= []
        @clients << socket
        puts "===> Received message: #{message}"
        @clients.each do |s|
          s.send({
            :type => "join",
            :data => {
              :room => "1111"
            }
            }.to_json)
        end
      end

      socket.onclose do
        puts "Client disconnected"
      end
    end
  end
end
end
