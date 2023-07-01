local socket = require("socket")

local function has_value(tab, value)
    for i, v in ipairs(tab) do
        if v == value then return i end
    end
    return false
end

local function checkOn(client)
   local line, err = client:receive()
	if line then
		client:send(line .. "\n")
	end
	if err and err ~= "timeout" then
		print(tostring(client) .. " " .. err)
		client:close()
		return true  -- end this connection
   end
	return false  -- do not end this connection
end

local server = assert(socket.bind("*",12321))
server:settimeout(0)  -- make non-blocking
local connections = { }  -- a list of the client connections
while true do
	local newClient = server:accept()
	if newClient then
		newClient:settimeout(0)  -- make non-blocking
		table.insert(connections, newClient)
	end
	local readList = socket.select({server, table.unpack(connections)})
	for _, conn in ipairs(readList) do
		if conn ~= server and checkOn(conn) then
			table.remove(connections, has_value(connections, conn))
		end
	end
end
