local socket=require("socket")

function checkOn (client)
    local line, err = client:receive()
    if line then
        print(tostring(client) .. " said " .. line)
        client:send(line .. "\n")
    end
    if err and err ~= "timeout" then
        print(tostring(client) .. " " .. err)
        client:close()
        return true  -- end this connection
    end
    return false    -- do not end this connection
end

local delay = 0.004  -- anything less than this uses up my CPU
local connections = {}  -- an array of connections
local newClient
local server = assert(socket.bind("*", 12321))
server:settimeout(delay)
while true do
    repeat
        newClient = server:accept()
        for idx, client in ipairs(connections) do
            if checkOn(client) then table.remove(connections, idx) end
        end
    until newClient
    newClient:settimeout(delay)
    print(tostring(newClient) .. " connected")
    table.insert(connections, newClient)
end
