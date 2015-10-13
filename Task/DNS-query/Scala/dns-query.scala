import java.net.{Inet4Address, Inet6Address, InetAddress}

object DnsQuery extends App {
  InetAddress.getAllByName("google.com").foreach {
    case x: Inet4Address => println(s"IPv4 : ${x.getHostAddress}")
    case x: Inet6Address => println(s"IPv6 : ${x.getHostAddress}")
  }
}
