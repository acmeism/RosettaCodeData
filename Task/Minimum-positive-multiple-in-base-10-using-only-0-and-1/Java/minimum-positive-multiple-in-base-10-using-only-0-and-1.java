import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

//  Title:  Minimum positive multiple in base 10 using only 0 and 1

public class MinimumNumberOnlyZeroAndOne {

    public static void main(String[] args) {
        for ( int n : getTestCases() ) {
            BigInteger result = getA004290(n);
            System.out.printf("A004290(%d) = %s = %s * %s%n", n, result, n, result.divide(BigInteger.valueOf(n)));
        }
    }

    private static List<Integer> getTestCases() {
        List<Integer> testCases = new ArrayList<>();
        for ( int i = 1 ; i <= 10 ; i++ ) {
            testCases.add(i);
        }
        for ( int i = 95 ; i <= 105 ; i++ ) {
            testCases.add(i);
        }
        for (int i : new int[] {297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878} ) {
            testCases.add(i);
        }
        return testCases;
    }

    private static BigInteger getA004290(int n) {
        if ( n == 1 ) {
            return BigInteger.valueOf(1);
        }
        int[][] L = new int[n][n];
        for ( int i = 2 ; i < n ; i++ ) {
            L[0][i] = 0;
        }
        L[0][0] = 1;
        L[0][1] = 1;
        int m = 0;
        BigInteger ten = BigInteger.valueOf(10);
        BigInteger nBi = BigInteger.valueOf(n);
        while ( true ) {
            m++;
            //  if L[m-1, (-10^m) mod n] = 1 then break
            if ( L[m-1][mod(ten.pow(m).negate(), nBi).intValue()] == 1 ) {
                break;
            }
            L[m][0] = 1;
            for ( int k = 1 ; k < n ; k++ ) {
                //L[m][k] = Math.max(L[m-1][k], L[m-1][mod(k-pow(10,m), n)]);
                L[m][k] = Math.max(L[m-1][k], L[m-1][mod(BigInteger.valueOf(k).subtract(ten.pow(m)), nBi).intValue()]);
            }

        }
        //int r = pow(10,m);
        //int k = mod(-pow(10,m), n);
        BigInteger r = ten.pow(m);
        BigInteger k = mod(r.negate(), nBi);
        for ( int j = m-1 ; j >= 1 ; j-- ) {
            if ( L[j-1][k.intValue()] == 0 ) {
                //r = r + pow(10, j);
                //k = mod(k-pow(10, j), n);
                r = r.add(ten.pow(j));
                k = mod(k.subtract(ten.pow(j)), nBi);
            }
        }
        if ( k.compareTo(BigInteger.ONE) == 0 ) {
            r = r.add(BigInteger.ONE);
        }
        return r;
    }

    private static BigInteger mod(BigInteger m, BigInteger n) {
        BigInteger result = m.mod(n);
        if ( result.compareTo(BigInteger.ZERO) < 0 ) {
            result = result.add(n);
        }
        return result;
    }

    @SuppressWarnings("unused")
    private static int mod(int m, int n) {
        int result = m % n;
        if ( result < 0 ) {
            result += n;
        }
        return result;
    }

    @SuppressWarnings("unused")
    private static int pow(int base, int exp) {
        return (int) Math.pow(base, exp);
    }
}
