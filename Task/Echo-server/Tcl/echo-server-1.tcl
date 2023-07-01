# How to handle an incoming new connection
proc acceptEcho {chan host port} {
    puts "opened connection from $host:$port"
    fconfigure $chan -blocking 0 -buffering line -translation crlf
    fileevent $chan readable [list echo $chan $host $port]
}

# How to handle an incoming message on a connection
proc echo {chan host port} {
    if {[gets $chan line] >= 0} {
        puts $chan $line
    } elseif {[eof $chan]} {
        close $chan
        puts "closed connection from $host:$port"
    }
    # Other conditions causing a short read need no action
}

# Make the server socket and wait for connections
socket -server acceptEcho -myaddr localhost 12321
vwait forever
