import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class ChernicksCarmichaelNumbers {

    public static void main(String[] args) {
        for ( long n = 3 ; n < 10 ; n++ ) {
            long m = 0;
            boolean foundComposite = true;
            List<Long> factors = null;
            while ( foundComposite ) {
                m += (n <= 4 ? 1 : (long) Math.pow(2, n-4) * 5);
                factors = U(n, m);
                foundComposite = false;
                for ( long factor : factors ) {
                    if ( ! isPrime(factor) ) {
                        foundComposite = true;
                        break;
                    }
                }
            }
            System.out.printf("U(%d, %d) = %s = %s %n", n, m, display(factors), multiply(factors));
        }
    }

    private static String display(List<Long> factors) {
        return factors.toString().replace("[", "").replace("]", "").replaceAll(", ", " * ");
    }

    private static BigInteger multiply(List<Long> factors) {
        BigInteger result = BigInteger.ONE;
        for ( long factor : factors ) {
            result = result.multiply(BigInteger.valueOf(factor));
        }
        return result;
    }

    private static List<Long> U(long n, long m) {
        List<Long> factors = new ArrayList<>();
        factors.add(6*m + 1);
        factors.add(12*m + 1);
        for ( int i = 1 ; i <= n-2 ; i++ ) {
            factors.add(((long)Math.pow(2, i)) * 9 * m + 1);
        }
        return factors;
    }

    private static final int MAX = 100_000;
    private static final boolean[] primes = new boolean[MAX];
    private static boolean SIEVE_COMPLETE = false;

    private static final boolean isPrimeTrivial(long test) {
        if ( ! SIEVE_COMPLETE ) {
            sieve();
            SIEVE_COMPLETE = true;
        }
        return primes[(int) test];
    }

    private static final void sieve() {
        //  primes
        for ( int i = 2 ; i < MAX ; i++ ) {
            primes[i] = true;
        }
        for ( int i = 2 ; i < MAX ; i++ ) {
            if ( primes[i] ) {
                for ( int j = 2*i ; j < MAX ; j += i ) {
                    primes[j] = false;
                }
            }
        }
    }

    //  See http://primes.utm.edu/glossary/page.php?sort=StrongPRP
    public static final boolean isPrime(long testValue) {
        if ( testValue == 2 ) return true;
        if ( testValue % 2 == 0 ) return false;
        if ( testValue <= MAX ) return isPrimeTrivial(testValue);
        long d = testValue-1;
        int s = 0;
        while ( d % 2 == 0 ) {
            s += 1;
            d /= 2;
        }
        if ( testValue < 1373565L ) {
            if ( ! aSrp(2, s, d, testValue) ) {
                return false;
            }
            if ( ! aSrp(3, s, d, testValue) ) {
                return false;
            }
            return true;
        }
        if ( testValue < 4759123141L ) {
            if ( ! aSrp(2, s, d, testValue) ) {
                return false;
            }
            if ( ! aSrp(7, s, d, testValue) ) {
                return false;
            }
            if ( ! aSrp(61, s, d, testValue) ) {
                return false;
            }
            return true;
        }
        if ( testValue < 10000000000000000L ) {
            if ( ! aSrp(3, s, d, testValue) ) {
                return false;
            }
            if ( ! aSrp(24251, s, d, testValue) ) {
                return false;
            }
            return true;
        }
        //  Try 5 "random" primes
        if ( ! aSrp(37, s, d, testValue) ) {
            return false;
        }
        if ( ! aSrp(47, s, d, testValue) ) {
            return false;
        }
        if ( ! aSrp(61, s, d, testValue) ) {
            return false;
        }
        if ( ! aSrp(73, s, d, testValue) ) {
            return false;
        }
        if ( ! aSrp(83, s, d, testValue) ) {
            return false;
        }
        //throw new RuntimeException("ERROR isPrime:  Value too large = "+testValue);
        return true;
    }

    private static final boolean aSrp(int a, int s, long d, long n) {
        long modPow = modPow(a, d, n);
        //System.out.println("a = "+a+", s = "+s+", d = "+d+", n = "+n+", modpow = "+modPow);
        if ( modPow == 1 ) {
            return true;
        }
        int twoExpR = 1;
        for ( int r = 0 ; r < s ; r++ ) {
            if ( modPow(modPow, twoExpR, n) == n-1 ) {
                return true;
            }
            twoExpR *= 2;
        }
        return false;
    }

    private static final long SQRT = (long) Math.sqrt(Long.MAX_VALUE);

    public static final long modPow(long base, long exponent, long modulus) {
        long result = 1;
        while ( exponent > 0 ) {
            if ( exponent % 2 == 1 ) {
                if ( result > SQRT || base > SQRT ) {
                    result = multiply(result, base, modulus);
                }
                else {
                    result = (result * base) % modulus;
                }
            }
            exponent >>= 1;
            if ( base > SQRT ) {
                base = multiply(base, base, modulus);
            }
            else {
                base = (base * base) % modulus;
            }
        }
        return result;
    }


    //  Result is a*b % mod, without overflow.
    public static final long multiply(long a, long b, long modulus) {
        long x = 0;
        long y = a % modulus;
        long t;
        while ( b > 0 ) {
            if ( b % 2 == 1 ) {
                t = x + y;
                x = (t > modulus ? t-modulus : t);
            }
            t = y << 1;
            y = (t > modulus ? t-modulus : t);
            b >>= 1;
        }
        return x % modulus;
    }

}
