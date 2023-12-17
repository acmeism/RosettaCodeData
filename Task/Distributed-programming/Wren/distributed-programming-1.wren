/* Distributed_programming_server.wren */

class Rpc {
    foreign static register()

    foreign static handleHTTP()
}

foreign class Listener {
    construct listen(network, address) {}
}

class HTTP {
    foreign static serve(listener)
}

Rpc.register()
Rpc.handleHTTP()
var listener = Listener.listen("tcp", ":1234")
HTTP.serve(listener)
