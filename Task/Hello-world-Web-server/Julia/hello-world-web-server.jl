using HttpServer
server = Server() do req, res
    "Goodbye, World!"
end
run(server, 8080)
