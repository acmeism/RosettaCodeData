-- Requires LuaSocket extension by Lua
-- Created by James A. Donnell Jr.
-- www.JamesDonnell.com

local baseURL = "http://api.macvendors.com/"

local function lookup(macAddress)
	http = require "socket.http"
	result, statuscode, content = http.request(baseURL .. macAddress)
	return result
end

local macAddress = "FC-A1-3E-2A-1C-33"
print(lookup(macAddress))
