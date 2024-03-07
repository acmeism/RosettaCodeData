/* Sockets.wren */

var AF_UNSPEC = 0
var SOCK_STREAM = 1

foreign class AddrInfo {
    foreign static getAddrInfo(name, service, req, pai)

    construct new() {}

    foreign family

    foreign family=(f)

    foreign sockType

    foreign sockType=(st)

    foreign protocol

    foreign addr

    foreign addrLen
}

foreign class AddrInfoPtr {
    construct new() {}

    foreign deref

    foreign free()
}

foreign class SockAddrPtr {
    construct new() {}
}

class Socket {
    foreign static create(domain, type, protocol)

    foreign static connect(fd, addr, len)

    foreign static send(fd, buf, n, flags)

    foreign static close(fd)
}

var msg = "hello socket world\n"
var hints = AddrInfo.new()
hints.family = AF_UNSPEC
hints.sockType = SOCK_STREAM
var addrInfoPtr = AddrInfoPtr.new()
if (AddrInfo.getAddrInfo("localhost", "256", hints, addrInfoPtr) == 0){
    var addrs = addrInfoPtr.deref
    var sock = Socket.create(addrs.family, addrs.sockType, addrs.protocol)
    if (sock >= 0) {
        var stat = Socket.connect(sock, addrs.addr, addrs.addrLen)
        if (stat >= 0) {
            var pm = msg
            while (true) {
                var len = pm.count
                var slen = Socket.send(sock, pm, len, 0)
                if (slen < 0 || slen >= len) break
                pm = pm[slen..-1]
            }
        } else if (stat == -1) {
            System.print("Connection refused.")
        }
        var status = Socket.close(sock)
        if (status != 0) System.print("Failed to close socket.")
    }
    addrInfoPtr.free()
}
