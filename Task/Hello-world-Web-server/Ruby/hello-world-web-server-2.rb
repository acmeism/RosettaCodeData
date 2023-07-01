require 'webrick'
WEBrick::HTTPServer.new(:Port => 80).tap {|srv|
    srv.mount_proc('/') {|request, response| response.body = "Goodbye, World!"}
}.start
