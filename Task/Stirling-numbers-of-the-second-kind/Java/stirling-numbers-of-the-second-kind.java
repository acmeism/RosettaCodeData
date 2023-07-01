import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

public class SterlingNumbersSecondKind {

    public static void main(String[] args) {
        System.out.println("Stirling numbers of the second kind:");
        int max = 12;
        System.out.printf("n/k");
        for ( int n = 0 ; n <= max ; n++ ) {
            System.out.printf("%10d", n);
        }
        System.out.printf("%n");
        for ( int n = 0 ; n <= max ; n++ ) {
            System.out.printf("%-3d", n);
            for ( int k = 0 ; k <= n ; k++ ) {
                System.out.printf("%10s", sterling2(n, k));
            }
            System.out.printf("%n");
        }
        System.out.println("The maximum value of S2(100, k) = ");
        BigInteger previous = BigInteger.ZERO;
        for ( int k = 1 ; k <= 100 ; k++ ) {
            BigInteger current = sterling2(100, k);
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

    private static final BigInteger sterling2(int n, int k) {
        String key = n + "," + k;
        if ( COMPUTED.containsKey(key) ) {
            return COMPUTED.get(key);
        }
        if ( n == 0 && k == 0 ) {
            return BigInteger.valueOf(1);
        }
        if ( (n > 0 && k == 0) || (n == 0 && k > 0) ) {
            return BigInteger.ZERO;
        }
        if ( n == k ) {
            return BigInteger.valueOf(1);
        }
        if ( k > n ) {
            return BigInteger.ZERO;
        }
        BigInteger result = BigInteger.valueOf(k).multiply(sterling2(n-1, k)).add(sterling2(n-1, k-1));
        COMPUTED.put(key, result);
        return result;
    }

}
