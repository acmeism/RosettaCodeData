import java.net.{InetAddress,Inet4Address,Inet6Address}

object DnsQuery extends App {
  val ipAddresses = InetAddress.getAllByName("www.kame.net");
  ipAddresses.foreach { ipAddr =>
    if (ipAddr.isInstanceOf[Inet4Address]) println("IPv4 : " + ipAddr.getHostAddress())
    else if (ipAddr.isInstanceOf[Inet6Address]) println("IPv6 : " + ipAddr.getHostAddress())
  }
}
