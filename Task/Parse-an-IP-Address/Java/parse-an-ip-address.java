import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ParseIPAddress {

    public static void main(String[] args) {
        String [] tests = new String[] {"192.168.0.1", "127.0.0.1", "256.0.0.1", "127.0.0.1:80", "::1", "[::1]:80", "[32e::12f]:80", "2605:2700:0:3::4713:93e3", "[2605:2700:0:3::4713:93e3]:80", "2001:db8:85a3:0:0:8a2e:370:7334"};
        System.out.printf("%-40s %-32s   %s%n", "Test Case", "Hex Address", "Port");
        for ( String ip : tests ) {
            try {
                String [] parsed = parseIP(ip);
                System.out.printf("%-40s %-32s   %s%n", ip, parsed[0], parsed[1]);
            }
            catch (IllegalArgumentException e) {
                System.out.printf("%-40s Invalid address:  %s%n", ip, e.getMessage());
            }
        }
    }

    private static final Pattern IPV4_PAT = Pattern.compile("^(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)(?::(\\d+)){0,1}$");
    private static final Pattern IPV6_DOUBL_COL_PAT = Pattern.compile("^\\[{0,1}([0-9a-f:]*)::([0-9a-f:]*)(?:\\]:(\\d+)){0,1}$");
    private static String ipv6Pattern;
    static {
        ipv6Pattern = "^\\[{0,1}";
        for ( int i = 1 ; i <= 7 ; i ++ ) {
            ipv6Pattern += "([0-9a-f]+):";
        }
        ipv6Pattern += "([0-9a-f]+)(?:\\]:(\\d+)){0,1}$";
    }
    private static final Pattern IPV6_PAT = Pattern.compile(ipv6Pattern);

    private static String[] parseIP(String ip) {
        String hex = "";
        String port = "";

        //  IPV4
        Matcher ipv4Matcher = IPV4_PAT.matcher(ip);
        if ( ipv4Matcher.matches() ) {
            for ( int i = 1 ; i <= 4 ; i++ ) {
                hex += toHex4(ipv4Matcher.group(i));
            }
            if ( ipv4Matcher.group(5) != null ) {
                port = ipv4Matcher.group(5);
            }
            return new String[] {hex, port};
        }

        //  IPV6, double colon
        Matcher ipv6DoubleColonMatcher = IPV6_DOUBL_COL_PAT.matcher(ip);
        if ( ipv6DoubleColonMatcher.matches() ) {
            String p1 = ipv6DoubleColonMatcher.group(1);
            if ( p1.isEmpty() ) {
                p1 = "0";
            }
            String p2 = ipv6DoubleColonMatcher.group(2);
            if ( p2.isEmpty() ) {
                p2 = "0";
            }
            ip =  p1 + getZero(8 - numCount(p1) - numCount(p2)) + p2;
            if ( ipv6DoubleColonMatcher.group(3) != null ) {
                ip = "[" + ip + "]:" + ipv6DoubleColonMatcher.group(3);
            }
        }

        //  IPV6
        Matcher ipv6Matcher = IPV6_PAT.matcher(ip);
        if ( ipv6Matcher.matches() ) {
            for ( int i = 1 ; i <= 8 ; i++ ) {
                hex += String.format("%4s", toHex6(ipv6Matcher.group(i))).replace(" ", "0");
            }
            if ( ipv6Matcher.group(9) != null ) {
                port = ipv6Matcher.group(9);
            }
            return new String[] {hex, port};
        }

        throw new IllegalArgumentException("ERROR 103: Unknown address: " + ip);
    }

    private static int numCount(String s) {
        return s.split(":").length;
    }

    private static String getZero(int count) {
        StringBuilder sb = new StringBuilder();
        sb.append(":");
        while ( count > 0 ) {
            sb.append("0:");
            count--;
        }
        return sb.toString();
    }

    private static String toHex4(String s) {
        int val = Integer.parseInt(s);
        if ( val < 0 || val > 255 ) {
            throw new IllegalArgumentException("ERROR 101:  Invalid value : " + s);
        }
        return String.format("%2s", Integer.toHexString(val)).replace(" ", "0");
    }

    private static String toHex6(String s) {
        int val = Integer.parseInt(s, 16);
        if ( val < 0 || val > 65536 ) {
            throw new IllegalArgumentException("ERROR 102:  Invalid hex value : " + s);
        }
        return s;
    }

}
