import java.net._

InetAddress.getAllByName("www.kame.net").foreach(x => println(x.getHostAddress))
