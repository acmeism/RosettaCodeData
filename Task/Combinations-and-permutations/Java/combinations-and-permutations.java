import java.math.BigInteger;

public class CombinationsAndPermutations {

    public static void main(String[] args) {
        System.out.println(Double.MAX_VALUE);
        System.out.println("A sample of permutations from 1 to 12 with exact Integer arithmetic:");
        for ( int n = 1 ; n <= 12 ; n++ ) {
            int k = n / 2;
            System.out.printf("%d P %d = %s%n", n, k, permutation(n, k));
        }

        System.out.println();
        System.out.println("A sample of combinations from 10 to 60 with exact Integer arithmetic:");
        for ( int n = 10 ; n <= 60 ; n += 5 ) {
            int k = n / 2;
            System.out.printf("%d C %d = %s%n", n, k, combination(n, k));
        }

        System.out.println();
        System.out.println("A sample of permutations from 5 to 15000 displayed in floating point arithmetic:");
        System.out.printf("%d P %d = %s%n", 5, 2, display(permutation(5, 2), 50));
        for ( int n = 1000 ; n <= 15000 ; n += 1000 ) {
            int k = n / 2;
            System.out.printf("%d P %d = %s%n", n, k, display(permutation(n, k), 50));
        }

        System.out.println();
        System.out.println("A sample of combinations from 100 to 1000 displayed in floating point arithmetic:");
        for ( int n = 100 ; n <= 1000 ; n += 100 ) {
            int k = n / 2;
            System.out.printf("%d C %d = %s%n", n, k, display(combination(n, k), 50));
        }

    }

    private static String display(BigInteger val, int precision) {
        String s = val.toString();
        precision = Math.min(precision, s.length());
        StringBuilder sb = new StringBuilder();
        sb.append(s.substring(0, 1));
        sb.append(".");
        sb.append(s.substring(1, precision));
        sb.append(" * 10^");
        sb.append(s.length()-1);
        return sb.toString();
    }

    public static BigInteger combination(int n, int k) {
        //  Select value with smallest intermediate results
        //    combination(n, k) = combination(n, n-k)
        if ( n-k < k ) {
            k = n-k;
        }
        BigInteger result = permutation(n, k);
        while ( k > 0 ) {
            result = result.divide(BigInteger.valueOf(k));
            k--;
        }
        return result;
    }

    public static BigInteger permutation(int n, int k) {
        BigInteger result = BigInteger.ONE;
        for ( int i = n ; i >= n-k+1 ; i-- ) {
            result = result.multiply(BigInteger.valueOf(i));
        }
        return result;
    }

}
