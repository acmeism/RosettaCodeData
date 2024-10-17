using Sockets # for version 1.0
println("Echo server on port 12321")
try
    server = listen(12321)
    instance = 0
    while true
        sock = accept(server)
        instance += 1
        socklabel = "$(getsockname(sock)) number $instance"
        @async begin
            println("Server connected to socket $socklabel")
            write(sock, "Connected to echo server.\r\n")
            while isopen(sock)
                str = readline(sock)
                write(sock,"$str\r\n")
                println("Echoed $str to socket $socklabel")
            end
            println("Closed socket $socklabel")
        end
    end
catch y
    println("Caught exception: $y")
end
