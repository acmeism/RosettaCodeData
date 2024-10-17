require "http/server"

server = HTTP::Server.new do |context|
    context.response.print "Goodbye World"
end

server.listen(8080)
