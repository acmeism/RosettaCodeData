local http = require("socket.http")
local url = require("socket.url")
local page = http.request('http://www.google.com/m/search?q=' .. url.escape("lua"))
print(page)
