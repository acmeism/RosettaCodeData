import std.getopt;
import std.socket;
import std.stdio;
import std.string;

struct client {
    int pos;
    char[] name;
    char[] buffer;
    Socket socket;
}

void broadcast(client[] connections, size_t self, const char[] message) {
    writeln(message);
    for (size_t i = 0; i < connections.length; i++) {
        if (i == self) continue;

        connections[i].socket.send(message);
        connections[i].socket.send("\r\n");
    }
}

bool registerClient(client[] connections, size_t self) {
    for (size_t i = 0; i < connections.length; i++) {
        if (i == self) continue;

        if (icmp(connections[i].name, connections[self].name) == 0) {
            return false;
        }
    }

    return true;
}

void main(string[] args) {
    ushort port = 4004;

    auto helpInformation = getopt
    (
        args,
        "port|p", "The port to listen to chat clients on [default is 4004]", &port
    );

    if (helpInformation.helpWanted) {
        defaultGetoptPrinter("A simple chat server based on a task in rosettacode.", helpInformation.options);
        return;
    }

    auto listener = new TcpSocket();
    assert(listener.isAlive);
    listener.blocking = false;
    listener.bind(new InternetAddress(port));
    listener.listen(10);
    writeln("Listening on port: ", port);

    enum MAX_CONNECTIONS = 60;
    auto socketSet = new SocketSet(MAX_CONNECTIONS + 1);
    client[] connections;

    while(true) {
        socketSet.add(listener);

        foreach (con; connections) {
            socketSet.add(con.socket);
        }

        Socket.select(socketSet, null, null);

        for (size_t i = 0; i < connections.length; i++) {
            if (socketSet.isSet(connections[i].socket)) {
                char[1024] buf;
                auto datLength = connections[i].socket.receive(buf[]);

                if (datLength == Socket.ERROR) {
                    writeln("Connection error.");
                } else if (datLength != 0) {
                    if (buf[0] == '\n' || buf[0] == '\r') {
                        if (connections[i].buffer == "/quit") {
                            connections[i].socket.close();
                            if (connections[i].name.length > 0) {
                                writeln("Connection from ", connections[i].name, " closed.");
                            } else {
                                writeln("Connection from ", connections[i].socket.remoteAddress(), " closed.");
                            }

                            connections[i] = connections[$-1];
                            connections.length--;
                            i--;

                            writeln("\tTotal connections: ", connections.length);
                            continue;
                        } else if (connections[i].name.length == 0) {
                            connections[i].buffer = strip(connections[i].buffer);
                            if (connections[i].buffer.length > 0) {
                                connections[i].name = connections[i].buffer;
                                if (registerClient(connections, i)) {
                                    connections.broadcast(i, "+++ " ~ connections[i].name ~ " arrived +++");
                                } else {
                                    connections[i].socket.send("Name already registered. Please enter your name: ");
                                    connections[i].name.length = 0;
                                }
                            } else {
                                connections[i].socket.send("A name is required. Please enter your name: ");
                            }
                        } else {
                            connections.broadcast(i, connections[i].name ~ "> " ~ connections[i].buffer);
                        }
                        connections[i].buffer.length = 0;
                    } else {
                        connections[i].buffer ~= buf[0..datLength];
                    }
                } else {
                    try {
                        if (connections[i].name.length > 0) {
                            writeln("Connection from ", connections[i].name, " closed.");
                        } else {
                            writeln("Connection from ", connections[i].socket.remoteAddress(), " closed.");
                        }
                    } catch (SocketException) {
                        writeln("Connection closed.");
                    }
                }
            }
        }

        if (socketSet.isSet(listener)) {
            Socket sn = null;
            scope(failure) {
                writeln("Error accepting");

                if (sn) {
                    sn.close();
                }
            }
            sn = listener.accept();
            assert(sn.isAlive);
            assert(listener.isAlive);

            if (connections.length < MAX_CONNECTIONS) {
                client newclient;

                writeln("Connection from ", sn.remoteAddress(), " established.");
                sn.send("Enter name: ");

                newclient.socket = sn;
                connections ~= newclient;

                writeln("\tTotal connections: ", connections.length);
            } else {
                writeln("Rejected connection from ", sn.remoteAddress(), "; too many connections.");
                sn.close();
                assert(!sn.isAlive);
                assert(listener.isAlive);
            }
        }

        socketSet.reset();
    }
}
