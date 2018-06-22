using HttpServer
using WebSockets

const connections = Dict{Int,WebSocket}()
const usernames   = Dict{Int,String}()

function decodeMessage( msg )
    String(copy(msg))
end


wsh = WebSocketHandler() do req, client
    global connections
    @show connections[client.id] = client
    println("req is $req")
    notifyonline = "Connection from user number $(client.id) is now online."
    for (k,v) in connections
        if k != client.id
            try
                write(v, notifyonline)
            catch
                continue
            end
        end
    end
    while true
        try
            msg = read(client)
        catch
            telloffline = "User $(usernames[client.id]) disconnected."
            println(telloffline, "(The client id was $(client.id).)")
            delete!(connections, client.id)
            if haskey(usernames, client.id)
                delete!(usernames, client.id)
            end
            for (k,v) in connections
                try
                    write(v, telloffline)
                catch
                    continue
                end
            end
            return
        end
        msg = decodeMessage(msg)
        if startswith(msg, "setusername:")
            println("SETTING USERNAME: $msg")
            usernames[client.id] = msg[13:end]
            notifyusername = "User number $(client.id) chose $(usernames[client.id]) as name handle."
            for (k,v) in connections
                try
                    write(v, notifyusername)
                catch
                    println("Caught exception writing to user $k")
                    continue
                end
            end
        end
        if startswith(msg, "say:")
            println("EMITTING MESSAGE: $msg")
            for (k,v) in connections
                if k != client.id
                    try
                        write(v, (usernames[client.id] * ": " * msg[5:end]))
                    catch
                        println("Caught exception writing to user $k")
                        continue
                    end
                end
            end
        end
    end
end

onepage = readstring(Pkg.dir("WebSockets","examples","chat-client.html"))
httph = HttpHandler() do req::Request, res::Response
  Response(onepage)
end

server = Server(httph, wsh)
println("Chat server listening on 8000...")
run(server,8000)
