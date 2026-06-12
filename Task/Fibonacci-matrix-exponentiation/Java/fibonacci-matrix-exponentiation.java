import java.math.BigInteger;
import java.util.Arrays;

public class FibonacciMatrixExponentiation {

    public static void main(String[] args) {
        BigInteger mod = BigInteger.TEN.pow(20);
        for ( int exp : Arrays.asList(32, 64) ) {
            System.out.printf("Last 20 digits of fib(2^%d) = %s%n", exp, fibMod(BigInteger.valueOf(2).pow(exp), mod));
        }

        for ( int i = 1 ; i <= 7 ; i++ ) {
            BigInteger n = BigInteger.TEN.pow(i);
            System.out.printf("fib(%,d) = %s%n", n, displayFib(fib(n)));
        }
    }

    private static String displayFib(BigInteger fib) {
        String s = fib.toString();
        if ( s.length() <= 40 ) {
            return s;
        }
        return s.substring(0, 20) + " ... " + s.subSequence(s.length()-20, s.length());
    }

    //  Use Matrix multiplication to compute Fibonacci numbers.
    private static BigInteger fib(BigInteger k) {
        BigInteger aRes = BigInteger.ZERO;
        BigInteger bRes = BigInteger.ONE;
        BigInteger cRes = BigInteger.ONE;
        BigInteger aBase = BigInteger.ZERO;
        BigInteger bBase = BigInteger.ONE;
        BigInteger cBase = BigInteger.ONE;
        while ( k.compareTo(BigInteger.ZERO) > 0 ) {
            if ( k.mod(BigInteger.valueOf(2)).compareTo(BigInteger.ONE) == 0 ) {
                BigInteger temp1 = aRes.multiply(aBase).add(bRes.multiply(bBase));
                BigInteger temp2 = aBase.multiply(bRes).add(bBase.multiply(cRes));
                BigInteger temp3 = bBase.multiply(bRes).add(cBase.multiply(cRes));
                aRes = temp1;
                bRes = temp2;
                cRes = temp3;
            }
            k = k.shiftRight(1);
            BigInteger temp1 = aBase.multiply(aBase).add(bBase.multiply(bBase));
            BigInteger temp2 = aBase.multiply(bBase).add(bBase.multiply(cBase));
            BigInteger temp3 = bBase.multiply(bBase).add(cBase.multiply(cBase));
            aBase = temp1;
            bBase = temp2;
            cBase = temp3;
        }
        return aRes;
    }

    //  Use Matrix multiplication to compute Fibonacci numbers.
    private static BigInteger fibMod(BigInteger k, BigInteger mod) {
        BigInteger aRes = BigInteger.ZERO;
        BigInteger bRes = BigInteger.ONE;
        BigInteger cRes = BigInteger.ONE;
        BigInteger aBase = BigInteger.ZERO;
        BigInteger bBase = BigInteger.ONE;
        BigInteger cBase = BigInteger.ONE;
        while ( k.compareTo(BigInteger.ZERO) > 0 ) {
            if ( k.mod(BigInteger.valueOf(2)).compareTo(BigInteger.ONE) == 0 ) {
                BigInteger temp1 = aRes.multiply(aBase).add(bRes.multiply(bBase)).mod(mod);
                BigInteger temp2 = aBase.multiply(bRes).add(bBase.multiply(cRes)).mod(mod);
                BigInteger temp3 = bBase.multiply(bRes).add(cBase.multiply(cRes)).mod(mod);
                aRes = temp1;
                bRes = temp2;
                cRes = temp3;
            }
            k = k.shiftRight(1);
            BigInteger temp1 = aBase.multiply(aBase).add(bBase.multiply(bBase)).mod(mod);
            BigInteger temp2 = aBase.multiply(bBase).add(bBase.multiply(cBase)).mod(mod);
            BigInteger temp3 = bBase.multiply(bBase).add(cBase.multiply(cBase)).mod(mod);
            aBase = temp1;
            bBase = temp2;
            cBase = temp3;
        }
        return aRes.mod(mod);
    }

}
