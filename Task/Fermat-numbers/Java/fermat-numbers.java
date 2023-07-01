import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class FermatNumbers {

    public static void main(String[] args) {
        System.out.println("First 10 Fermat numbers:");
        for ( int i = 0 ; i < 10 ; i++ ) {
            System.out.printf("F[%d] = %s\n", i, fermat(i));
        }
        System.out.printf("%nFirst 12 Fermat numbers factored:%n");
        for ( int i = 0 ; i < 13 ; i++ ) {
            System.out.printf("F[%d] = %s\n", i, getString(getFactors(i, fermat(i))));
        }
    }

    private static String getString(List<BigInteger> factors) {
        if ( factors.size() == 1 ) {
            return factors.get(0) + " (PRIME)";
        }
        return factors.stream().map(v -> v.toString()).map(v -> v.startsWith("-") ? "(C" + v.replace("-", "") + ")" : v).collect(Collectors.joining(" * "));
    }

    private static Map<Integer, String> COMPOSITE = new HashMap<>();
    static {
        COMPOSITE.put(9, "5529");
        COMPOSITE.put(10, "6078");
        COMPOSITE.put(11, "1037");
        COMPOSITE.put(12, "5488");
        COMPOSITE.put(13, "2884");
    }

    private static List<BigInteger> getFactors(int fermatIndex, BigInteger n) {
        List<BigInteger> factors = new ArrayList<>();
        BigInteger factor = BigInteger.ONE;
        while ( true ) {
            if ( n.isProbablePrime(100) ) {
                factors.add(n);
                break;
            }
            else {
                if ( COMPOSITE.containsKey(fermatIndex) ) {
                    String stop = COMPOSITE.get(fermatIndex);
                    if ( n.toString().startsWith(stop) ) {
                        factors.add(new BigInteger("-" + n.toString().length()));
                        break;
                    }
                }
                factor = pollardRhoFast(n);
                if ( factor.compareTo(BigInteger.ZERO) == 0 ) {
                    factors.add(n);
                    break;
                }
                else {
                    factors.add(factor);
                    n = n.divide(factor);
                }
            }
        }
        return factors;
    }

    private static final BigInteger TWO = BigInteger.valueOf(2);

    private static BigInteger fermat(int n) {
        return TWO.pow((int)Math.pow(2, n)).add(BigInteger.ONE);
    }

    //  See:  https://en.wikipedia.org/wiki/Pollard%27s_rho_algorithm
    @SuppressWarnings("unused")
    private static BigInteger pollardRho(BigInteger n) {
        BigInteger x = BigInteger.valueOf(2);
        BigInteger y = BigInteger.valueOf(2);
        BigInteger d = BigInteger.ONE;
        while ( d.compareTo(BigInteger.ONE) == 0 ) {
            x = pollardRhoG(x, n);
            y = pollardRhoG(pollardRhoG(y, n), n);
            d = x.subtract(y).abs().gcd(n);
        }
        if ( d.compareTo(n) == 0 ) {
            return BigInteger.ZERO;
        }
        return d;
    }

    //  Includes Speed Up of 100 multiples and 1 GCD, instead of 100 multiples and 100 GCDs.
    //  See Variants section of Wikipedia article.
    //  Testing F[8] = 1238926361552897 * Prime
    //    This variant = 32 sec.
    //    Standard algorithm = 107 sec.
    private static BigInteger pollardRhoFast(BigInteger n) {
        long start = System.currentTimeMillis();
        BigInteger x = BigInteger.valueOf(2);
        BigInteger y = BigInteger.valueOf(2);
        BigInteger d = BigInteger.ONE;
        int count = 0;
        BigInteger z = BigInteger.ONE;
        while ( true ) {
            x = pollardRhoG(x, n);
            y = pollardRhoG(pollardRhoG(y, n), n);
            d = x.subtract(y).abs();
            z = z.multiply(d).mod(n);
            count++;
            if ( count == 100 ) {
                d = z.gcd(n);
                if ( d.compareTo(BigInteger.ONE) != 0 ) {
                    break;
                }
                z = BigInteger.ONE;
                count = 0;
            }
        }
        long end = System.currentTimeMillis();
        System.out.printf("    Pollard rho try factor %s elapsed time = %d ms (factor = %s).%n", n, (end-start), d);
        if ( d.compareTo(n) == 0 ) {
            return BigInteger.ZERO;
        }
        return d;
    }

    private static BigInteger pollardRhoG(BigInteger x, BigInteger n) {
        return x.multiply(x).add(BigInteger.ONE).mod(n);
    }

}
