using Sockets

const portnum = 12345

function canopen()
    try
        server = listen(portnum)
        println("This is the only instance.")
        sleep(20)
    catch y
        if findfirst("EADDRINUSE", string(y)) != nothing
            println("There is already an instance running.")
        end
    end
end

canopen()
