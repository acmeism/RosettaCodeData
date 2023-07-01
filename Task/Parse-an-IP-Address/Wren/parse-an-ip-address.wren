import "/dynamic" for Enum, Tuple
import "/big" for BigInt
import "/str" for Str
import "/fmt" for Conv, Fmt

var AddressSpace = Enum.create("AddressSpace", ["IPv4", "IPv6", "Invalid"])

// a port of -1 denotes 'not specified'
var IPAddressComponents = Tuple.create("IPAddressComponents", ["address", "addressSpace", "port"])

var INVALID = IPAddressComponents.new(BigInt.zero, AddressSpace.Invalid, 0)

var ipAddressParse = Fn.new { |ipAddress|
    var addressSpace = AddressSpace.IPv4
    var ipa = Str.lower(ipAddress)
    var port = -1
    var trans = false

    if (ipa.startsWith("::ffff:") && ipa.contains(".")) {
        addressSpace = AddressSpace.IPv6
        trans = true
        ipa = ipa[7..-1]
    } else if (ipa.startsWith("[::ffff:") && ipa.contains(".")) {
        addressSpace = AddressSpace.IPv6
        trans = true
        ipa = ipa[8..-1].replace("]", "")
    }
    var octets = ipa.split(".")[-1..0].toList
    var address = BigInt.zero
    if (octets.count == 4) {
        var split = octets[0].split(":")
        if (split.count == 2) {
            var temp = Num.fromString(split[1])
            if (!temp || temp < 0 || temp > 65535) return INVALID
            port = temp
            octets[0] = split[0]
        }
        for (i in 0..3) {
            var num = Num.fromString(octets[i])
            if (!num || num < 0 || num > 255) return INVALID
            var bigNum = BigInt.new(num)
            address = address | (bigNum << (i * 8))
        }
        if (trans) address = address + BigInt.fromBaseString("ffff00000000", 16)
    } else if (octets.count == 1) {
        addressSpace = AddressSpace.IPv6
        if (ipa[0] == "[") {
            ipa = ipa[1..-1]
            var split = ipa.split("]:")
            if (split.count != 2) return INVALID
            var temp = Num.fromString(split[1])
            if (!temp || temp < 0 || temp > 65535) return INVALID
            port = temp
            ipa = ipa[0...(-2 - split[1].count)]
        }
        var hextets = ipa.split(":")[-1..0].toList
        var len = hextets.count

        if (ipa.startsWith("::")) {
            hextets[-1] = "0"
        } else if (ipa.endsWith("::")) {
            hextets[0] = "0"
        }
        if (ipa == "::") hextets[1] = "0"
        if (len > 8 || (len == 8 && hextets.any { |h| h == "" }) || hextets.count { |h| h == "" } > 1) {
            return INVALID
        }
        if (len < 8) {
            var insertions = 8 - len
            for (i in 0..7) {
                if (hextets[i] == "") {
                    hextets[i] = "0"
                    while (insertions > 0) {
                        insertions = insertions - 1
                        hextets.insert(i, "0")
                    }
                    break
                }
            }
        }
        for (j in 0..7) {
            var num = Conv.atoi(hextets[j], 16)
            if (num > 0xFFFF) return INVALID
            var bigNum = BigInt.new(num)
            address = address | (bigNum << (j * 16))
        }
    } else return INVALID

    return IPAddressComponents.new(address, addressSpace, port)
}

var ipas = [
    "127.0.0.1",
    "127.0.0.1:80",
    "::1",
    "[::1]:80",
    "2605:2700:0:3::4713:93e3",
    "[2605:2700:0:3::4713:93e3]:80",
    "::ffff:192.168.173.22",
    "[::ffff:192.168.173.22]:80",
    "1::",
    "::",
    "256.0.0.0",
    "::ffff:127.0.0.0.1"
]
for (ipa in ipas) {
    var ipac = ipAddressParse.call(ipa)
    Fmt.print("IP address    : $s", ipa)
    Fmt.print("Address       : $s", Str.upper(ipac.address.toBaseString(16)))
    Fmt.print("Address Space : $s", AddressSpace.members[ipac.addressSpace])
    Fmt.print("Port          : $s", (ipac.port == -1) ? "not specified" : ipac.port.toString)
    System.print()
}
