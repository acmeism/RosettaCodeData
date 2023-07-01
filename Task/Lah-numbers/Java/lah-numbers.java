import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

public class LahNumbers {

    public static void main(String[] args) {
        System.out.println("Show the unsigned Lah numbers up to n = 12:");
        for ( int n = 0 ; n <= 12 ; n++ ) {
            System.out.printf("%5s", n);
            for ( int k = 0 ; k <= n ; k++ ) {
                System.out.printf("%12s", lahNumber(n, k));
            }
            System.out.printf("%n");
        }

        System.out.println("Show the maximum value of L(100, k):");
        int n = 100;
        BigInteger max = BigInteger.ZERO;
        for ( int k = 0 ; k <= n ; k++ ) {
            max = max.max(lahNumber(n, k));
        }
        System.out.printf("%s", max);
    }

    private static Map<String,BigInteger> CACHE = new HashMap<>();

    private static BigInteger lahNumber(int n, int k) {
        String key = n + "," + k;
        if ( CACHE.containsKey(key) ) {
            return CACHE.get(key);
        }

        //  L(n,0) = 0;
        BigInteger result;
        if ( n == 0 && k == 0 ) {
            result = BigInteger.ONE;
        }
        else if ( k == 0 ) {
            result = BigInteger.ZERO;
        }
        else if ( k > n ) {
            result = BigInteger.ZERO;
        }
        else if ( n == 1 && k == 1 ) {
            result = BigInteger.ONE;
        }
        else {
            result = BigInteger.valueOf(n-1+k).multiply(lahNumber(n-1,k)).add(lahNumber(n-1,k-1));
        }

        CACHE.put(key, result);

        return result;
    }

}
