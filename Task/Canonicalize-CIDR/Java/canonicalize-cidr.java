import java.text.MessageFormat;
import java.text.ParseException;

public class CanonicalizeCIDR {
    public static void main(String[] args) {
        for (String test : TESTS) {
            try {
                CIDR cidr = new CIDR(test);
                System.out.printf("%-18s -> %s\n", test, cidr.toString());
            } catch (Exception ex) {
                System.err.printf("Error parsing '%s': %s\n", test, ex.getLocalizedMessage());
            }
        }
    }

    private static class CIDR {
        private CIDR(int address, int maskLength) {
            this.address = address;
            this.maskLength = maskLength;
        }

        private CIDR(String str) throws Exception {
            Object[] args = new MessageFormat(FORMAT).parse(str);
            int address = 0;
            for (int i = 0; i < 4; ++i) {
                int a = ((Number)args[i]).intValue();
                if (a < 0 || a > 255)
                    throw new Exception("Invalid IP address");
                address <<= 8;
                address += a;
            }
            int maskLength = ((Number)args[4]).intValue();
            if (maskLength < 1 || maskLength > 32)
                throw new Exception("Invalid mask length");
            int mask = ~((1 << (32 - maskLength)) - 1);
            this.address = address & mask;
            this.maskLength = maskLength;
        }

        public String toString() {
            int address = this.address;
            int d = address & 0xFF;
            address >>= 8;
            int c = address & 0xFF;
            address >>= 8;
            int b = address & 0xFF;
            address >>= 8;
            int a = address & 0xFF;
            Object[] args = { a, b, c, d, maskLength };
            return new MessageFormat(FORMAT).format(args);
        }

        private int address;
        private int maskLength;
        private static final String FORMAT = "{0,number,integer}.{1,number,integer}.{2,number,integer}.{3,number,integer}/{4,number,integer}";
    };

    private static final String[] TESTS = {
        "87.70.141.1/22",
        "36.18.154.103/12",
        "62.62.197.11/29",
        "67.137.119.181/4",
        "161.214.74.21/24",
        "184.232.176.184/18"
    };
}
