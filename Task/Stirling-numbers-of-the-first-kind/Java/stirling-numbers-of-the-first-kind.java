import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

public class SterlingNumbersFirstKind {

    public static void main(String[] args) {
        System.out.println("Unsigned Stirling numbers of the first kind:");
        int max = 12;
        System.out.printf("n/k");
        for ( int n = 0 ; n <= max ; n++ ) {
            System.out.printf("%10d", n);
        }
        System.out.printf("%n");
        for ( int n = 0 ; n <= max ; n++ ) {
            System.out.printf("%-3d", n);
            for ( int k = 0 ; k <= n ; k++ ) {
                System.out.printf("%10s", sterling1(n, k));
            }
            System.out.printf("%n");
        }
        System.out.println("The maximum value of S1(100, k) = ");
        BigInteger previous = BigInteger.ZERO;
        for ( int k = 1 ; k <= 100 ; k++ ) {
            BigInteger current = sterling1(100, k);
            if ( current.compareTo(previous) > 0 ) {
                previous = current;
            }
            else {
                System.out.printf("%s%n(%d digits, k = %d)%n", previous, previous.toString().length(), k-1);
                break;
            }
        }
    }

    private static Map<String,BigInteger> COMPUTED = new HashMap<>();

    private static final BigInteger sterling1(int n, int k) {
        String key = n + "," + k;
        if ( COMPUTED.containsKey(key) ) {
            return COMPUTED.get(key);
        }
        if ( n == 0 && k == 0 ) {
            return BigInteger.valueOf(1);
        }
        if ( n > 0 && k == 0 ) {
            return BigInteger.ZERO;
        }
        if ( k > n ) {
            return BigInteger.ZERO;
        }
        BigInteger result = sterling1(n-1, k-1).add(BigInteger.valueOf(n-1).multiply(sterling1(n-1, k)));
        COMPUTED.put(key, result);
        return result;
    }

}
