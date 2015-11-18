import java.net.InetAddress;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.UnknownHostException;

class DnsQuery {
    public static void main(String[] args) {
        try {
            InetAddress[] ipAddr = InetAddress.getAllByName("www.kame.net");
            for(int i=0; i < ipAddr.length ; i++) {
                if (ipAddr[i] instanceof Inet4Address) {
                    System.out.println("IPv4 : " + ipAddr[i].getHostAddress());
                } else if (ipAddr[i] instanceof Inet6Address) {
                    System.out.println("IPv6 : " + ipAddr[i].getHostAddress());
                }
            }
        } catch (UnknownHostException uhe) {
            System.err.println("unknown host");
        }
    }
}
