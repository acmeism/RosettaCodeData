local socket = require "socket"
local headers = "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=UTF-8\r\nContent-Length: %d\r\n\r\n%s"
local content = "<!doctype html><html><title>Goodbye, World!</title><h1>Goodbye, World!"
local server = assert(socket.bind("localhost", 8080))
repeat
   local client = server:accept()
   local ok = client:send(string.format(headers, #content, content))
   client:close()
until not client or not ok
server:close()
