// version 1.1.3

import java.net.InetAddress
import java.net.Inet4Address
import java.net.Inet6Address

fun showIPAddresses(host: String) {
    try {
        val ipas = InetAddress.getAllByName(host)
        println("The IP address(es) for '$host' is/are:\n")
        for (ipa in ipas) {
            print(when (ipa) {
                is Inet4Address -> "  ipv4 : "
                is Inet6Address -> "  ipv6 : "
                else            -> "  ipv? : "
            })
            println(ipa.hostAddress)
        }
    }
    catch (ex: Exception) {
        println(ex.message)
    }
}

fun main(args: Array<String>) {
    showIPAddresses("www.kame.net")
}
