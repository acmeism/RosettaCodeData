import java.math.BigInteger;
import java.util.*;
import static java.util.Arrays.asList;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;
import static java.lang.Math.min;

public class Test {

    static List<BigInteger> cumu(int n) {
        List<List<BigInteger>> cache = new ArrayList<>();
        cache.add(asList(BigInteger.ONE));

        for (int L = cache.size(); L < n + 1; L++) {
            List<BigInteger> r = new ArrayList<>();
            r.add(BigInteger.ZERO);
            for (int x = 1; x < L + 1; x++)
                r.add(r.get(r.size() - 1).add(cache.get(L - x).get(min(x, L - x))));
            cache.add(r);
        }
        return cache.get(n);
    }

    static List<BigInteger> row(int n) {
        List<BigInteger> r = cumu(n);
        return range(0, n).mapToObj(i -> r.get(i + 1).subtract(r.get(i)))
                .collect(toList());
    }

    public static void main(String[] args) {
        System.out.println("Rows:");
        for (int x = 1; x < 11; x++)
            System.out.printf("%2d: %s%n", x, row(x));

        System.out.println("\nSums:");
        for (int x : new int[]{23, 123, 1234}) {
            List<BigInteger> c = cumu(x);
            System.out.printf("%s %s%n", x, c.get(c.size() - 1));
        }
    }
}
