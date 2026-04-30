import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.util.Arrays;
import java.util.List;

public class NumberSuffix {
    private static final String suffixes = " KMGTPEZYXWVU";
    private static final BigDecimal GGOOL = googol();

    private static BigDecimal googol() {
        BigDecimal g1 = new BigDecimal("10000000000");
        BigDecimal g = new BigDecimal("10000000000");
        for (int i = 2; i <= 10; i++) {
            g = g.multiply(g1);
        }
        return g;
    }

    private static void suffize(String arg) {
        String[] fields = arg.trim().split("\\s+");
        String a = fields[0].replace(",", "");
        if (a.isEmpty()) {
            a = "0";
        }

        int places = -1;
        int base = 10;
        String frac = "";
        String radix = "";

        switch (fields.length) {
            case 1:
                places = -1;
                base = 10;
                break;
            case 2:
                places = Integer.parseInt(fields[1]);
                frac = fields[1];
                base = 10;
                break;
            case 3:
                if (fields[1].equals(",")) {
                    places = 0;
                    frac = ",";
                } else {
                    places = Integer.parseInt(fields[1]);
                    frac = fields[1];
                }
                base = Integer.parseInt(fields[2]);
                if (base != 2 && base != 10) {
                    base = 10;
                }
                radix = fields[2];
                break;
        }

        String sign = "";
        if (a.charAt(0) == '+' || a.charAt(0) == '-') {
            sign = String.valueOf(a.charAt(0));
            a = a.substring(1);
        }

        BigDecimal b = new BigDecimal(a);
        BigDecimal d;
        boolean g = b.compareTo(GGOOL) >= 0;

        if (!g && base == 2) {
            d = new BigDecimal("1024");
        } else if (!g && base == 10) {
            d = new BigDecimal("1000");
        } else {
            d = GGOOL;
        }

        int c = 0;
        while (b.compareTo(d) >= 0 && c < 12) {
            b = b.divide(d, 500, RoundingMode.HALF_UP);
            c++;
        }

        String suffix;
        if (!g) {
            suffix = String.valueOf(suffixes.charAt(c));
        } else {
            suffix = "googol";
        }

        if (base == 2) {
            suffix += "i";
        }

        System.out.println("   input number = " + fields[0]);
        System.out.println("  fraction digs = " + frac);
        System.out.println("specified radix = " + radix);
        System.out.print("     new number = ");

        if (places >= 0) {
            System.out.printf("%s%." + places + "f%s%n", sign, b, suffix);
        } else {
            System.out.printf("%s%s%s%n", sign, b.toPlainString(), suffix);
        }
        System.out.println();
    }

    public static void main(String[] args) {
        List<String> tests = Arrays.asList(
            "87,654,321",
            "-998,877,665,544,332,211,000      3",
            "+112,233                          0",
            "16,777,216                        1",
            "456,789,100,000,000",
            "456,789,100,000,000               2      10",
            "456,789,100,000,000               5       2",
            "456,789,100,000.000e+00           0      10",
            "+16777216                         ,       2",
            "1.2e101",
            "446,835,273,728                   1",
            "1e36",
            "1e39"
        );

        for (String test : tests) {
            suffize(test);
        }
    }
}
