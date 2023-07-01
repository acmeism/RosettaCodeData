import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class NSmoothNumbers {

    public static void main(String[] args) {
        System.out.printf("show the first 25 n-smooth numbers for n = 2 through n = 29%n");
        int max = 25;
        List<BigInteger> primes = new ArrayList<>();
        for ( int n = 2 ; n <= 29 ; n++ ) {
            if ( isPrime(n) ) {
                primes.add(BigInteger.valueOf(n));
                System.out.printf("The first %d %d-smooth numbers:%n", max, n);
                BigInteger[] humble = nSmooth(max, primes.toArray(new BigInteger[0]));
                for ( int i = 0 ; i < max ; i++ ) {
                    System.out.printf("%s ", humble[i]);
                }
                System.out.printf("%n%n");
            }
        }

        System.out.printf("show three numbers starting with 3,000 for n-smooth numbers for n = 3 through n = 29%n");
        int count = 3;
        max = 3000 + count - 1;
        primes = new ArrayList<>();
        primes.add(BigInteger.valueOf(2));
        for ( int n = 3 ; n <= 29 ; n++ ) {
            if ( isPrime(n) ) {
                primes.add(BigInteger.valueOf(n));
                System.out.printf("The %d through %d %d-smooth numbers:%n", max-count+1, max, n);
                BigInteger[] nSmooth = nSmooth(max, primes.toArray(new BigInteger[0]));
                for ( int i = max-count ; i < max ; i++ ) {
                    System.out.printf("%s ", nSmooth[i]);
                }
                System.out.printf("%n%n");
            }
        }

        System.out.printf("Show twenty numbers starting with 30,000 n-smooth numbers for n=503 through n=521%n");
        count = 20;
        max = 30000 + count - 1;
        primes = new ArrayList<>();
        for ( int n = 2 ; n <= 521 ; n++ ) {
            if ( isPrime(n) ) {
                primes.add(BigInteger.valueOf(n));
                if ( n >= 503 && n <= 521 ) {
                    System.out.printf("The %d through %d %d-smooth numbers:%n", max-count+1, max, n);
                    BigInteger[] nSmooth = nSmooth(max, primes.toArray(new BigInteger[0]));
                    for ( int i = max-count ; i < max ; i++ ) {
                        System.out.printf("%s ", nSmooth[i]);
                    }
                    System.out.printf("%n%n");
                }
            }
        }

    }

    private static final boolean isPrime(long test) {
        if ( test == 2 ) {
            return true;
        }
        if ( test % 2 == 0 ) return false;
        for ( long i = 3 ; i <= Math.sqrt(test) ; i += 2 ) {
            if ( test % i == 0 ) {
                return false;
            }
        }
        return true;
    }

    private static BigInteger[] nSmooth(int n, BigInteger[] primes) {
        int size = primes.length;
        BigInteger[] test = new BigInteger[size];
        for ( int i = 0 ; i < size ; i++ ) {
            test[i] = primes[i];
        }
        BigInteger[] results = new BigInteger[n];
        results[0] = BigInteger.ONE;

        int[] indexes = new int[size];
        for ( int i = 0 ; i < size ; i++ ) {
            indexes[i] = 0;
        }

        for ( int index = 1 ; index < n ; index++ ) {
            BigInteger min = test[0];
            for ( int i = 1 ; i < size ; i++ ) {
                min = min.min(test[i]);
            }
            results[index] = min;

            for ( int i = 0 ; i < size ; i++ ) {
                if ( results[index].compareTo(test[i]) == 0 ) {
                    indexes[i] = indexes[i] + 1;
                    test[i] = primes[i].multiply(results[indexes[i]]);
                }
            }
        }
        return results;
    }

}
