import java.util.List;
import java.util.Map;
import java.util.Objects;

public class NegativeBaseNumbers {
    private static final String DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    private static String encodeNegBase(long n, int b) {
        if (b < -62 || b > -1) throw new IllegalArgumentException("Parameter b is out of bounds");
        if (n == 0) return "0";
        StringBuilder out = new StringBuilder();
        long nn = n;
        while (nn != 0) {
            int rem = (int) (nn % b);
            nn /= b;
            if (rem < 0) {
                nn++;
                rem -= b;
            }
            out.append(DIGITS.charAt(rem));
        }
        out.reverse();
        return out.toString();
    }

    private static long decodeNegBase(String ns, int b) {
        if (b < -62 || b > -1) throw new IllegalArgumentException("Parameter b is out of bounds");
        if (Objects.equals(ns, "0")) return 0;
        long total = 0;
        long bb = 1;
        for (int i = ns.length() - 1; i >= 0; i--) {
            char c = ns.charAt(i);
            total += DIGITS.indexOf(c) * bb;
            bb *= b;
        }
        return total;
    }

    public static void main(String[] args) {
        List<Map.Entry<Long, Integer>> nbl = List.of(
                Map.entry(10L, -2),
                Map.entry(146L, -3),
                Map.entry(15L, -10),
                Map.entry(-4393346L, -62)
        );
        for (Map.Entry<Long, Integer> p : nbl) {
            String ns = encodeNegBase(p.getKey(), p.getValue());
            System.out.printf("%12d encoded in base %-3d = %s\n", p.getKey(), p.getValue(), ns);
            long n = decodeNegBase(ns, p.getValue());
            System.out.printf("%12s decoded in base %-3d = %d\n\n", ns, p.getValue(), n);
        }
    }
}
