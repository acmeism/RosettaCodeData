import std.stdio, std.socket, std.array;

void main() {
    enum ushort port = 7;
    enum int backlog = 10;
    enum int max_connections = 60;
    enum BUFFER_SIZE = 16;

    auto listener = new TcpSocket;
    assert(listener.isAlive);
    listener.bind(new InternetAddress(port));
    listener.listen(backlog);
    debug writeln("Listening on port ", port);

    // Room for listener.
    auto sset = new SocketSet(max_connections + 1);

    Socket[] sockets;
    char[BUFFER_SIZE] buf;

    for (;; sset.reset()) {
        sset.add(listener);
        foreach (each; sockets)
            sset.add(each);

        // Update socket set with only those sockets that have data
        // avaliable for reading. Options are for read, write,
        // and error.
        Socket.select(sset, null, null);

        // Read the data from each socket remaining, and handle
        // the request.
        for (int i = 0; ; i++) {
NEXT:
            if (i == sockets.length)
                break;
            if (sset.isSet(sockets[i])) {
                int read = sockets[i].receive(buf);
                if (Socket.ERROR == read) {
                    debug writeln("Connection error.");
                    goto SOCK_DOWN;
                } else if (read == 0) {
                    debug {
                        try {
                            // If the connection closed due to an
                            // error, remoteAddress() could fail.
                            writefln("Connection from %s closed.",
                                     sockets[i].remoteAddress()
                                     .toString());
                        } catch (SocketException) {
                            writeln("Connection closed.");
                        }
                    }
SOCK_DOWN:
                    sockets[i].close(); //Release socket resources now.

                    // Remove from socket from sockets, and id from
                    // threads.
                    if (i != sockets.length - 1)
                        sockets[i] = sockets.back;
                    sockets.length--;
                    debug writeln("\tTotal connections: ",
                                  sockets.length);
                    goto NEXT; // -i- is still the NEXT index.
                } else {
                    debug
                        writefln("Received %d bytes from %s:"
                                 ~ "\n-----\n%s\n-----",
                                 read,
                                 sockets[i].remoteAddress().toString(),
                                 buf[0 .. read]);

                    // Echo what was sent.
                    sockets[i].send(buf[0 .. read]);
                }
            }
        }

        // Connection request.
        if (sset.isSet(listener)) {
            Socket sn;
            try {
                if (sockets.length < max_connections) {
                    sn = listener.accept();
                    debug writefln("Connection from %s established.",
                                   sn.remoteAddress().toString());
                    assert(sn.isAlive);
                    assert(listener.isAlive);
                    sockets ~= sn;
                    debug writefln("\tTotal connections: %d",
                                   sockets.length);
                } else {
                    sn = listener.accept();
                    debug writefln("Rejected connection from %s;"
                                   ~ " too many connections.",
                                   sn.remoteAddress().toString());
                    assert(sn.isAlive);
                    sn.close();
                    assert(!sn.isAlive);
                    assert(listener.isAlive);
                }
            } catch (Exception e) {
                debug writefln("Error accepting: %s", e.toString());
                if (sn)
                    sn.close();
            }
        }
    }
}
