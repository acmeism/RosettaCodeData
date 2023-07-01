import java.math.BigInteger;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;

public class PierpontPrimes {

    public static void main(String[] args) {
        NumberFormat nf = NumberFormat.getNumberInstance();
        display("First 50 Pierpont primes of the first kind:", pierpontPrimes(50, true));
        display("First 50 Pierpont primes of the second kind:", pierpontPrimes(50, false));
        System.out.printf("250th Pierpont prime of the first kind:     %s%n%n", nf.format(pierpontPrimes(250, true).get(249)));
        System.out.printf("250th Pierpont prime of the second kind: %s%n%n", nf.format(pierpontPrimes(250, false).get(249)));
    }

    private static void display(String message, List<BigInteger> primes) {
        NumberFormat nf = NumberFormat.getNumberInstance();
        System.out.printf("%s%n", message);
        for ( int i = 1 ; i <= primes.size() ; i++ ) {
            System.out.printf("%10s  ", nf.format(primes.get(i-1)));
            if ( i % 10 == 0 ) {
                System.out.printf("%n");
            }
        }
        System.out.printf("%n");
    }

    public static List<BigInteger> pierpontPrimes(int n, boolean first) {
        List<BigInteger> primes = new ArrayList<BigInteger>();
        if ( first ) {
            primes.add(BigInteger.valueOf(2));
            n -= 1;
        }

        BigInteger two = BigInteger.valueOf(2);
        BigInteger twoTest = two;
        BigInteger three = BigInteger.valueOf(3);
        BigInteger threeTest = three;
        int twoIndex = 0, threeIndex = 0;
        List<BigInteger> twoSmooth = new ArrayList<BigInteger>();

        BigInteger one = BigInteger.ONE;
        BigInteger mOne = BigInteger.valueOf(-1);
        int count = 0;
        while ( count < n ) {
            BigInteger min = twoTest.min(threeTest);
            twoSmooth.add(min);
            if ( min.compareTo(twoTest) == 0 ) {
                twoTest = two.multiply(twoSmooth.get(twoIndex));
                twoIndex++;
            }
            if ( min.compareTo(threeTest) == 0 ) {
                threeTest = three.multiply(twoSmooth.get(threeIndex));
                threeIndex++;
            }
            BigInteger test = min.add(first ? one : mOne);
            if ( test.isProbablePrime(10) ) {
                primes.add(test);
                count++;
            }
        }
        return primes;
    }

}
