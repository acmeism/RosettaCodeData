require("socket")

function checkOn (client)
    local line, err = client:receive()
    if line then
        print(tostring(client) .. " said " .. line)
        client:send(line .. "\n")
    end
    if err and err ~= "timeout" then
        print(tostring(client) .. " " .. err)
        client:close()
        return err
    end
    return nil
end

local delay, clients, newClient = 10^-6, {}
local server = assert(socket.bind("*", 12321))
server:settimeout(delay)
print("Server started")
while 1 do
    repeat
        newClient = server:accept()
        for k, v in pairs(clients) do
            if checkOn(v) then table.remove(clients, k) end
        end
    until newClient
    newClient:settimeout(delay)
    print(tostring(newClient) .. " connected")
    table.insert(clients, newClient)
end
