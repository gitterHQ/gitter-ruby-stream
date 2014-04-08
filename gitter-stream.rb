require 'eventmachine'
require 'em-http'
require 'json'

token       = ENV['TOKEN']
room_id     = ENV['ROOM_ID']
stream_url  = "https://stream.gitter.im/v1/rooms/#{room_id}/chatMessages"

http = EM::HttpRequest.new(stream_url, keepalive: true, connect_timeout: 0, inactivity_timeout: 0)

EventMachine.run do
  req = http.get(head: {'Authorization' => "Bearer #{token}", 'accept' => 'application/json'})

  req.stream do |chunk|
    unless chunk.strip.empty?
      message = JSON.parse(chunk)
      p [:message, message]
    end
  end
end
