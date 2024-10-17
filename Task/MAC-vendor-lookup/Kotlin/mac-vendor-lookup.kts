// version 1.1.2

import java.net.URL

fun lookupVendor(mac: String) = URL("http://api.macvendors.com/" + mac).readText()

fun main(args: Array<String>) {
    val macs = arrayOf("FC-A1-3E", "FC:FB:FB:01:FA:21", "88:53:2E:67:07:BE", "D4:F4:6F:C9:EF:8D")
    for (mac in macs) println(lookupVendor(mac))
}
