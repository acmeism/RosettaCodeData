/* echo_server.wren */

var MAX_ENQUEUED = 20
var BUF_LEN = 256
var PORT_STR = "12321"

var AF_UNSPEC = 0
var SOCK_STREAM = 1
var AI_PASSIVE = 1

foreign class AddrInfo {
    foreign static getAddrInfo(name, service, req, pai)

    construct new() {}

    foreign family

    foreign family=(f)

    foreign sockType

    foreign sockType=(st)

    foreign flags

    foreign flags=(f)

    foreign protocol

    foreign addr

    foreign addrLen
}

foreign class AddrInfoPtr {
    construct new() {}

    foreign deref

    foreign free()
}

class Socket {
    foreign static create(domain, type, protocol)

    foreign static bind(fd, addr, len)

    foreign static listen(fd, n)

    foreign static accept(fd, addr, addrLen)
}

foreign class SockAddrPtr {
    construct new() {}

    foreign size
}

class SigAction {
    foreign static cleanUpProcesses()
}

foreign class Buffer {
    construct new(size) {}
}

class Posix {
    foreign static read(fd, buf, nbytes)

    foreign static write(fd, buf, n)

    foreign static fork()

    foreign static close(fd)
}

// Child process.
var echoLines = Fn.new { |csock|
    var buf = Buffer.new(BUF_LEN)
    var r
    while ((r = Posix.read(csock, buf, BUF_LEN)) > 0) {
        Posix.write(csock, buf, r)
    }
}

// Parent process.
var takeConnectionsForever = Fn.new { |ssock|
    while (true) {
        var addr = SockAddrPtr.new()
        var addrSize = addr.size

        /* Block until we take one connection to the server socket */
        var csock = Socket.accept(ssock, addr, addrSize)

        /* If it was a successful connection, spawn a worker process to service it. */
        if (csock == -1) {
            System.print("Error accepting socket.")
        } else if (Posix.fork() == 0) {
            Posix.close(ssock)
            echoLines.call(csock)
            return
        } else {
            Posix.close(csock)
        }
    }
}

/* Look up the address to bind to. */
var hints = AddrInfo.new()
hints.family = AF_UNSPEC
hints.sockType = SOCK_STREAM
hints.flags = AI_PASSIVE
var addrInfoPtr = AddrInfoPtr.new()
if (AddrInfo.getAddrInfo("", PORT_STR, hints, addrInfoPtr) != 0) {
    Fiber.abort("Failed to get pointer to addressinfo.")
}

/* Make a socket. */
var res = addrInfoPtr.deref
var sock = Socket.create(res.family, res.sockType, res.protocol)
if (sock == -1) Fiber.abort("Failed to make a socket.")

/* Arrange to clean up child processes (the workers). */
SigAction.cleanUpProcesses()

/* Associate the socket with its address. */
if (Socket.bind(sock, res.addr, res.addrLen) != 0) {
    Fiber.abort("Failed to bind socket.")
}

addrInfoPtr.free()

/* State that we've opened a server socket and are listening for connections. */
if (Socket.listen(sock, MAX_ENQUEUED) != 0) {
    Fiber.abort("Failed to listen for connections.")
}

/* Serve the listening socket until killed */
takeConnectionsForever.call(sock)
