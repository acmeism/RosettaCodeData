server-port: open/lines tcp://:12321
forever [
    connection-port: first server-port
    until [
        wait connection-port
        error? try [insert connection-port first connection-port]
    ]
    close connection-port
]
close server-port
