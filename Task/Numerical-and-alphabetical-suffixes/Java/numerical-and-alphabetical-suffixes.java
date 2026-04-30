import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.Map;

class MinMult {
    int min;
    double mult;

    public MinMult(int min, double mult) {
        this.min = min;
        this.mult = mult;
    }
}

public class Main {
    private static final Map<String, MinMult> abbrevs = new HashMap<>();
    private static final Map<String, Double> metric = new HashMap<>();
    private static final Map<String, Double> binary = new HashMap<>();

    static {
        abbrevs.put("PAIRS", new MinMult(4, 2));
        abbrevs.put("SCORES", new MinMult(3, 20));
        abbrevs.put("DOZENS", new MinMult(3, 12));
        abbrevs.put("GROSS", new MinMult(2, 144));
        abbrevs.put("GREATGROSS", new MinMult(7, 1728));
        abbrevs.put("GOOGOLS", new MinMult(6, 1e100));

        metric.put("K", 1e3);
        metric.put("M", 1e6);
        metric.put("G", 1e9);
        metric.put("T", 1e12);
        metric.put("P", 1e15);
        metric.put("E", 1e18);
        metric.put("Z", 1e21);
        metric.put("Y", 1e24);
        metric.put("X", 1e27);
        metric.put("W", 1e30);
        metric.put("V", 1e33);
        metric.put("U", 1e36);

        binary.put("Ki", Math.pow(2, 10));
        binary.put("Mi", Math.pow(2, 20));
        binary.put("Gi", Math.pow(2, 30));
        binary.put("Ti", Math.pow(2, 40));
        binary.put("Pi", Math.pow(2, 50));
        binary.put("Ei", Math.pow(2, 60));
        binary.put("Zi", Math.pow(2, 70));
        binary.put("Yi", Math.pow(2, 80));
        binary.put("Xi", Math.pow(2, 90));
        binary.put("Wi", Math.pow(2, 100));
        binary.put("Vi", Math.pow(2, 110));
        binary.put("Ui", Math.pow(2, 120));
    }

    private static BigDecimal googol() {
        BigDecimal g1 = new BigDecimal("10000000000");
        BigDecimal g = new BigDecimal("10000000000");
        for (int i = 2; i <= 10; i++) {
            g = g.multiply(g1);
        }
        return g;
    }

    private static int fact(String num, int d) {
        int prod = 1;
        int n = Integer.parseInt(num);
        for (int i = n; i > 0; i -= d) {
            prod *= i;
        }
        return prod;
    }

    private static BigDecimal parse(String number) {
        int i;
        for (i = number.length() - 1; i >= 0; i--) {
            if (Character.isDigit(number.charAt(i))) {
                break;
            }
        }
        String num = number.substring(0, i + 1).replace(",", "");
        String suf = number.substring(i + 1).toUpperCase();

        BigDecimal bf = new BigDecimal(num);
        if (suf.isEmpty()) {
            return bf;
        }

        if (suf.charAt(0) == '!') {
            int prod = fact(num, suf.length());
            return new BigDecimal(prod);
        }

        for (Map.Entry<String, MinMult> entry : abbrevs.entrySet()) {
            String k = entry.getKey();
            MinMult v = entry.getValue();
            if (suf.startsWith(k) && suf.length() >= v.min) {
                BigDecimal t1 = new BigDecimal(num);
                BigDecimal t2;
                if (!k.equals("GOOGOLS")) {
                    t2 = new BigDecimal(v.mult);
                } else {
                    t2 = googol();
                }
                return t1.multiply(t2);
            }
        }

        for (Map.Entry<String, Double> entry : metric.entrySet()) {
            String k = entry.getKey();
            Double v = entry.getValue();
            for (int j = 0; j < suf.length(); j++) {
                if (j + 1 <= suf.length() && k.equals(suf.substring(j, j + 1))) {
                    if (j + 1 < suf.length() && suf.charAt(j + 1) == 'I') {
                        bf = bf.multiply(new BigDecimal(binary.get(k + "i")));
                        j++;
                    } else {
                        bf = bf.multiply(new BigDecimal(v));
                    }
                }
            }
        }
        return bf;
    }

    private static String commatize(String s) {
        if (s.isEmpty()) {
            return "";
        }
        boolean neg = s.charAt(0) == '-';
        if (neg) {
            s = s.substring(1);
        }
        String frac = "";
        int ix = s.indexOf('.');
        if (ix >= 0) {
            frac = s.substring(ix);
            s = s.substring(0, ix);
        }
        int le = s.length();
        for (int i = le - 3; i >= 1; i -= 3) {
            s = s.substring(0, i) + "," + s.substring(i);
        }
        if (!neg) {
            return s + frac;
        }
        return "-" + s + frac;
    }

    private static void process(String[] numbers) {
        System.out.print("numbers =  ");
        for (String number : numbers) {
            System.out.printf("%s  ", number);
        }
        System.out.print("\nresults =  ");
        for (String number : numbers) {
            BigDecimal res = parse(number);
            String t = res.toPlainString();
            System.out.printf("%s  ", commatize(t));
        }
        System.out.println("\n");
    }

    public static void main(String[] args) {
        String[] numbers = {"2greatGRo", "24Gros", "288Doz", "1,728pairs", "172.8SCOre"};
        process(numbers);
        numbers = new String[]{"1,567", "+1.567k", "0.1567e-2m"};
        process(numbers);
        numbers = new String[]{"25.123kK", "25.123m", "2.5123e-00002G"};
        process(numbers);
        numbers = new String[]{"25.123kiKI", "25.123Mi", "2.5123e-00002Gi", "+.25123E-7Ei"};
        process(numbers);
        numbers = new String[]{"-.25123e-34Vikki", "2e-77gooGols"};
        process(numbers);
        numbers = new String[]{"9!", "9!!", "9!!!", "9!!!!", "9!!!!!", "9!!!!!!", "9!!!!!!!", "9!!!!!!!!", "9!!!!!!!!!"};
        process(numbers);
    }
}
