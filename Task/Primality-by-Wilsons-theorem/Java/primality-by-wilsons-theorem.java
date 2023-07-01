import java.math.BigInteger;

public class PrimaltyByWilsonsTheorem {

    public static void main(String[] args) {
        System.out.printf("Primes less than 100 testing by Wilson's Theorem%n");
        for ( int i = 0 ; i <= 100 ; i++ ) {
            if ( isPrime(i) ) {
                System.out.printf("%d ", i);
            }
        }
    }


    private static boolean isPrime(long p) {
        if ( p <= 1) {
            return false;
        }
        return fact(p-1).add(BigInteger.ONE).mod(BigInteger.valueOf(p)).compareTo(BigInteger.ZERO) == 0;
    }

    private static BigInteger fact(long n) {
        BigInteger fact = BigInteger.ONE;
        for ( int i = 2 ; i <= n ; i++ ) {
            fact = fact.multiply(BigInteger.valueOf(i));
        }
        return fact;
    }

}
