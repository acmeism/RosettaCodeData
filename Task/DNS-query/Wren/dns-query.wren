import "os" for Process

var domainName = "www.kame.net"
System.print(domainName)
var ipvs = ["IPv4", "IPv6"]
var args = ["A", "AAAA"]
for (i in 0..1) {
    var cmd = "nslookup -querytype=%(args[i]) %(domainName)"
    var lines = Process.read(cmd).split("\n")
    var addresses = []
    for (line in lines.skip(3)) {
        if (line.startsWith("Address:")) {
            var address = line[8..-1].trim()
            addresses.add(address)
        }
    }
    for (address in addresses) System.print("%(ipvs[i]): %(address)")
}
