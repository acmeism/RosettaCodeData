/* DNS_query.wren */

class Net {
    foreign static lookupHost(host)
}

var host = "orange.kame.net"
var addrs = Net.lookupHost(host).split(", ")
System.print(addrs.join("\n"))
