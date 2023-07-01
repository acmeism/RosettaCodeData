import std.array, std.socket;

void main() {
    auto listener = new TcpSocket;
    assert(listener.isAlive);
    listener.bind(new InternetAddress(12321));
    listener.listen(10);

    Socket currSock;
    uint bytesRead;
    ubyte[1] buff;

    while (true) {
        currSock = listener.accept();
        while ((bytesRead = currSock.receive(buff)) > 0)
            currSock.send(buff);
        currSock.close();
        buff.clear();
    }
}
