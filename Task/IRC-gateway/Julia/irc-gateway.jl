using Sockets

const BUFFER_SIZE = 4096

""" IRC Gateway for connecting to an IRC server and a chat server """
struct IRCMessage
    prefix::String
    comando::String
    params::Vector{String}
    paramcount::Int
end

""" IRCGateway structure to hold connection details and state """
mutable struct IRCGateway
    ircsocket::Union{TCPSocket,Nothing}
    chatsocket::Union{TCPSocket,Nothing}
    ircserver::String
    ircport::Int
    chatserver::String
    chatport::Int
    nickname::String
    channel::String
    connected::Bool
    IRCGateway(ircserver, ircport, chatserver, chatport, nickname, channel) =
        new(nothing, nothing, ircserver, ircport, chatserver, chatport, nickname, channel, false)
end

""" Parses an IRC message string into an IRCMessage structure """
function parseIRCMessage(msg::String)::IRCMessage
    params = Vector{String}(undef, 16)  # 0-based index in original code translates to 1-based in Julia
    paramcount = 0
    prefix = ""
    comando = ""

    # Prefix
    if startswith(msg, ":")
        spacepos = findfirst(' ', msg)
        if spacepos !== nothing
            prefix = msg[2:spacepos-1]
            msg = msg[spacepos+1:end]
        end
    end

    # Command
    spacepos = findfirst(' ', msg)
    if spacepos === nothing
        comando = strip(msg)
        return IRCMessage(prefix, comando, params[1:paramcount], paramcount)
    end
    comando = msg[1:spacepos-1]
    msg = msg[spacepos+1:end]

    # Parameters
    while !isempty(strip(msg))
        if startswith(msg, ":")
            paramcount += 1
            params[paramcount] = msg[2:end]
            break
        end
        spacepos = findfirst(' ', msg)
        if spacepos === nothing
            paramcount += 1
            params[paramcount] = strip(msg)
            break
        end
        paramcount += 1
        params[paramcount] = msg[1:spacepos-1]
        msg = msg[spacepos+1:end]
    end

    return IRCMessage(prefix, comando, params[1:paramcount], paramcount)
end

function connect!(gateway::IRCGateway)
    try
        # Connect to IRCserver
        gateway.ircsocket = connect(gateway.ircserver, gateway.ircport)

        # Send commands
        sendIRC(gateway, "NICK $(gateway.nickname)\r\n")
        sendIRC(gateway, "USER $(gateway.nickname) 0 * :IRC Gateway\r\n")
        sendIRC(gateway, "JOIN $(gateway.channel)\r\n")
        gateway.connected = true
        println("Connected to IRC server: $(gateway.ircserver):$(gateway.ircport)",
           " as $(gateway.nickname) in channel $(gateway.channel)")
        # Connect chat
        gateway.chatsocket = connect(gateway.chatserver, gateway.chatport)

    catch e
        println("Connection failed: $e")
        gateway.connected = false
    end
end

function sendIRC(gateway::IRCGateway, msg::String)
    if gateway.ircsocket !== nothing
        write(gateway.ircsocket, msg)
    end
end

function sendchat(gateway::IRCGateway, msg::String)
    if gateway.chatsocket !== nothing
        write(gateway.chatsocket, msg)
    end
end

function processIRCmessage(gateway::IRCGateway, msg::String)
    parsed = parseIRCMessage(msg)

    if parsed.comando == "PRIVMSG" && parsed.paramcount >= 2
        if parsed.params[1] == gateway.channel
            nick = split(parsed.prefix, "!")[1]
            sendchat(gateway, "$nick: $(parsed.params[2])\r\n")
        end
    elseif parsed.comando == "PING"
        sendIRC(gateway, "PONG $(parsed.params[1])\r\n")
    end
end

function processchatmessage(gateway::IRCGateway, msg::String)
    if !isempty(msg)
        sendIRC(gateway, "PRIVMSG $(gateway.channel) :$msg\r\n")
    end
end

function main()
    gateway = IRCGateway(
        "fiery.ca.us.swiftirc.net",
        6667,
        "127.0.0.1",
        8080,
        "Rosetta",
        "#programming"
    )
    connect!(gateway)

    # Message loop
    buffer = Vector{UInt8}(undef, BUFFER_SIZE)
    while gateway.connected
        # Check IRC socket
        if gateway.ircsocket !== nothing && isreadable(gateway.ircsocket)
            try
                bytesreceived = readbytes!(gateway.ircsocket, buffer, BUFFER_SIZE-1)
                if bytesreceived > 0
                    msg = String(buffer[1:bytesreceived])
                    processIRCmessage(gateway, msg)
                end
            catch e
                println("IRC read error: $e")
                gateway.connected = false
            end
        end

        # Check chat socket
        if gateway.chatsocket !== nothing && isreadable(gateway.chatsocket)
            try
                bytesreceived = readbytes!(gateway.chatsocket, buffer, BUFFER_SIZE-1)
                if bytesreceived > 0
                    msg = String(buffer[1:bytesreceived])
                    processchatmessage(gateway, msg)
                end
            catch e
                println("Chat read error: $e")
                gateway.connected = false
            end
        end
        sleep(0.002 * rand()) # Prevent busy waiting
    end

    # Done
    if gateway.ircsocket !== nothing
        close(gateway.ircsocket)
    end
    if gateway.chatsocket !== nothing
        close(gateway.chatsocket)
    end
end

# Run the program
main()
