# How to handle an incoming new connection
proc acceptEcho {chan host port} {
    puts "opened connection from $host:$port"
    fconfigure $chan -translation binary -buffering none
    fcopy $chan $chan -command [list done $chan $host $port]
}

# Called to finalize the connection
proc done {chan host port args} {
    puts "closed connection from $host:$port"
    close $chan
}

# Make the server socket and wait for connections
socket -server acceptEcho -myaddr localhost 12321
vwait forever
