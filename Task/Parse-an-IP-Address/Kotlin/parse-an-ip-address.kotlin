// version 1.1.3

import java.math.BigInteger

enum class AddressSpace { IPv4, IPv6, Invalid }

data class IPAddressComponents(
    val address: BigInteger,
    val addressSpace: AddressSpace,
    val port: Int  // -1 denotes 'not specified'
)

val INVALID = IPAddressComponents(BigInteger.ZERO, AddressSpace.Invalid, 0)

fun ipAddressParse(ipAddress: String): IPAddressComponents {
    var addressSpace = AddressSpace.IPv4
    var ipa = ipAddress.toLowerCase()
    var port = -1
    var trans = false

    if (ipa.startsWith("::ffff:") && '.' in ipa) {
        addressSpace = AddressSpace.IPv6
        trans = true
        ipa = ipa.drop(7)
    }
    else if (ipa.startsWith("[::ffff:") && '.' in ipa) {
        addressSpace = AddressSpace.IPv6
        trans = true
        ipa = ipa.drop(8).replace("]", "")
    }
    val octets = ipa.split('.').reversed().toTypedArray()
    var address = BigInteger.ZERO
    if (octets.size == 4) {
        val split = octets[0].split(':')
        if (split.size == 2) {
            val temp = split[1].toIntOrNull()
            if (temp == null || temp !in 0..65535) return INVALID
            port = temp
            octets[0] = split[0]
        }

        for (i in 0..3) {
            val num = octets[i].toLongOrNull()
            if (num == null || num !in 0..255) return INVALID
            val bigNum = BigInteger.valueOf(num)
            address = address.or(bigNum.shiftLeft(i * 8))
        }

        if (trans) address += BigInteger("ffff00000000", 16)
    }
    else if (octets.size == 1) {
        addressSpace = AddressSpace.IPv6
        if (ipa[0] == '[') {
            ipa = ipa.drop(1)
            val split = ipa.split("]:")
            if (split.size != 2) return INVALID
            val temp = split[1].toIntOrNull()
            if (temp == null || temp !in 0..65535) return INVALID
            port = temp
            ipa = ipa.dropLast(2 + split[1].length)
        }
        val hextets = ipa.split(':').reversed().toMutableList()
        val len = hextets.size

        if (ipa.startsWith("::"))
            hextets[len - 1] = "0"
        else if (ipa.endsWith("::"))
            hextets[0] = "0"

        if (ipa == "::") hextets[1] = "0"
        if (len > 8 || (len == 8 && hextets.any { it == "" }) || hextets.count { it == "" } > 1)
            return INVALID
        if (len < 8) {
            var insertions = 8 - len
            for (i in 0..7) {
                if (hextets[i] == "") {
                    hextets[i] = "0"
                    while (insertions-- > 0) hextets.add(i, "0")
                    break
                }
            }
        }
        for (j in 0..7) {
            val num = hextets[j].toLongOrNull(16)
            if (num == null || num !in 0x0..0xFFFF) return INVALID
            val bigNum = BigInteger.valueOf(num)
            address = address.or(bigNum.shiftLeft(j * 16))
        }
    }
    else return INVALID

    return IPAddressComponents(address, addressSpace, port)
}

fun main(args: Array<String>) {
    val ipas = listOf(
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
    )
    for (ipa in ipas) {
        val (address, addressSpace, port) = ipAddressParse(ipa)
        println("IP address    : $ipa")
        println("Address       : ${"%X".format(address)}")
        println("Address Space : $addressSpace")
        println("Port          : ${if (port == -1) "not specified" else port.toString()}")
        println()
    }
}
