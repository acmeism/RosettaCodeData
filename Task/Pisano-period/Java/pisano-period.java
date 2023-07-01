import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class PisanoPeriod {

    public static void main(String[] args) {
        System.out.printf("Print pisano(p^2) for every prime p lower than 15%n");
        for ( long i = 2 ; i < 15 ; i++ ) {
            if ( isPrime(i) ) {
                long n = i*i;
                System.out.printf("pisano(%d) = %d%n", n, pisano(n));
            }
        }

        System.out.printf("%nPrint pisano(p) for every prime p lower than 180%n");
        for ( long n = 2 ; n < 180 ; n++ ) {
            if ( isPrime(n) ) {
                System.out.printf("pisano(%d) = %d%n", n, pisano(n));
            }
        }

        System.out.printf("%nPrint pisano(n) for every integer from 1 to 180%n");
        for ( long n = 1 ; n <= 180 ; n++ ) {
            System.out.printf("%3d  ", pisano(n));
            if ( n % 10 == 0 ) {
                System.out.printf("%n");
            }
        }


    }

    private static final boolean isPrime(long test) {
        if ( test == 2 ) {
            return true;
        }
        if ( test % 2 == 0 ) {
            return false;
        }
        for ( long i = 3 ; i <= Math.sqrt(test) ; i += 2 ) {
            if ( test % i == 0 ) {
                return false;
            }
        }
        return true;
    }


    private static Map<Long,Long> PERIOD_MEMO = new HashMap<>();
    static {
        PERIOD_MEMO.put(2L, 3L);
        PERIOD_MEMO.put(3L, 8L);
        PERIOD_MEMO.put(5L, 20L);
    }

    //  See http://webspace.ship.edu/msrenault/fibonacci/fib.htm
    private static long pisano(long n) {
        if ( PERIOD_MEMO.containsKey(n) ) {
            return PERIOD_MEMO.get(n);
        }
        if ( n == 1 ) {
            return 1;
        }
        Map<Long,Long> factors = getFactors(n);

        //  Special cases
        //  pisano(2^k) = 3*n/2
        if ( factors.size() == 1 & factors.get(2L) != null && factors.get(2L) > 0 ) {
            long result = 3 * n / 2;
            PERIOD_MEMO.put(n, result);
            return result;
        }
        //  pisano(5^k) = 4*n
        if ( factors.size() == 1 & factors.get(5L) != null && factors.get(5L) > 0 ) {
            long result = 4*n;
            PERIOD_MEMO.put(n, result);
            return result;
        }
        //  pisano(2*5^k) = 6*n
        if ( factors.size() == 2 & factors.get(2L) != null && factors.get(2L) == 1 && factors.get(5L) != null && factors.get(5L) > 0 ) {
            long result = 6*n;
            PERIOD_MEMO.put(n, result);
            return result;
        }

        List<Long> primes = new ArrayList<>(factors.keySet());
        long prime = primes.get(0);
        if ( factors.size() == 1 && factors.get(prime) == 1 ) {
            List<Long> divisors = new ArrayList<>();
            if ( n % 10 == 1 || n % 10 == 9 ) {
                for ( long divisor : getDivisors(prime-1) ) {
                    if ( divisor % 2 == 0 ) {
                        divisors.add(divisor);
                    }
                }
            }
            else {
                List<Long> pPlus1Divisors = getDivisors(prime+1);
                for ( long divisor : getDivisors(2*prime+2) ) {
                    if ( !  pPlus1Divisors.contains(divisor) ) {
                        divisors.add(divisor);
                    }
                }
            }
            Collections.sort(divisors);
            for ( long divisor : divisors ) {
                if ( fibModIdentity(divisor, prime) ) {
                    PERIOD_MEMO.put(prime, divisor);
                    return divisor;
                }
            }
            throw new RuntimeException("ERROR 144: Divisor not found.");
        }
        long period = (long) Math.pow(prime, factors.get(prime)-1) * pisano(prime);
        for ( int i = 1 ; i < primes.size() ; i++ ) {
            prime = primes.get(i);
            period = lcm(period, (long) Math.pow(prime, factors.get(prime)-1) * pisano(prime));
        }
        PERIOD_MEMO.put(n, period);
        return period;
    }

    //  Use Matrix multiplication to compute Fibonacci numbers.
    private static boolean fibModIdentity(long n, long mod) {
        long aRes = 0;
        long bRes = 1;
        long cRes = 1;
        long aBase = 0;
        long bBase = 1;
        long cBase = 1;
        while ( n > 0 ) {
            if ( n % 2 == 1 ) {
                long temp1 = 0, temp2 = 0, temp3 = 0;
                if ( aRes > SQRT || aBase > SQRT || bRes > SQRT || bBase > SQRT || cBase > SQRT || cRes > SQRT ) {
                    temp1 = (multiply(aRes, aBase, mod) + multiply(bRes, bBase, mod)) % mod;
                    temp2 = (multiply(aBase, bRes, mod) + multiply(bBase, cRes, mod)) % mod;
                    temp3 = (multiply(bBase, bRes, mod) + multiply(cBase, cRes, mod)) % mod;
                }
                else {
                    temp1 = ((aRes*aBase % mod) + (bRes*bBase % mod)) % mod;
                    temp2 = ((aBase*bRes % mod) + (bBase*cRes % mod)) % mod;
                    temp3 = ((bBase*bRes % mod) + (cBase*cRes % mod)) % mod;
                }
                aRes = temp1;
                bRes = temp2;
                cRes = temp3;
            }
            n >>= 1L;
            long temp1 = 0, temp2 = 0, temp3 = 0;
            if ( aBase > SQRT || bBase > SQRT || cBase > SQRT ) {
                temp1 = (multiply(aBase, aBase, mod) + multiply(bBase, bBase, mod)) % mod;
                temp2 = (multiply(aBase, bBase, mod) + multiply(bBase, cBase, mod)) % mod;
                temp3 = (multiply(bBase, bBase, mod) + multiply(cBase, cBase, mod)) % mod;
            }
            else {
                temp1 = ((aBase*aBase % mod) + (bBase*bBase % mod)) % mod;
                temp2 = ((aBase*bBase % mod) + (bBase*cBase % mod)) % mod;
                temp3 = ((bBase*bBase % mod) + (cBase*cBase % mod)) % mod;
            }
            aBase = temp1;
            bBase = temp2;
            cBase = temp3;
        }
        return aRes % mod == 0 && bRes % mod == 1 && cRes % mod == 1;
    }

    private static final long SQRT = (long) Math.sqrt(Long.MAX_VALUE);

    //  Result is a*b % mod, without overflow.
    public static final long multiply(long a, long b, long modulus) {
        //System.out.println("    multiply : a = " + a + ", b = " + b + ", mod = " + modulus);
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
        //System.out.println("    multiply : answer = " + (x % modulus));
        return x % modulus;
    }

    private static final List<Long> getDivisors(long number) {
        List<Long> divisors = new ArrayList<>();
        long sqrt = (long) Math.sqrt(number);
        for ( long i = 1 ; i <= sqrt ; i++ ) {
            if ( number % i == 0 ) {
                divisors.add(i);
                long div = number / i;
                if ( div != i ) {
                    divisors.add(div);
                }
            }
        }
        return divisors;
    }

    public static long lcm(long a, long b) {
        return a*b/gcd(a,b);
    }

    public static long gcd(long a, long b) {
        if ( b == 0 ) {
            return a;
        }
        return gcd(b, a%b);
    }

    private static final Map<Long,Map<Long,Long>> allFactors = new TreeMap<Long,Map<Long,Long>>();
    static {
        Map<Long,Long> factors = new TreeMap<Long,Long>();
        factors.put(2L, 1L);
        allFactors.put(2L, factors);
    }

    public static Long MAX_ALL_FACTORS = 100000L;

    public static final Map<Long,Long> getFactors(Long number) {
        if ( allFactors.containsKey(number) ) {
            return allFactors.get(number);
        }
        Map<Long,Long> factors = new TreeMap<Long,Long>();
        if ( number % 2 == 0 ) {
            Map<Long,Long> factorsdDivTwo = getFactors(number/2);
            factors.putAll(factorsdDivTwo);
            factors.merge(2L, 1L, (v1, v2) -> v1 + v2);
            if ( number < MAX_ALL_FACTORS ) {
                allFactors.put(number, factors);
            }
            return factors;
        }
        boolean prime = true;
        long sqrt = (long) Math.sqrt(number);
        for ( long i = 3 ; i <= sqrt ; i += 2 ) {
            if ( number % i == 0 ) {
                prime = false;
                factors.putAll(getFactors(number/i));
                factors.merge(i, 1L, (v1, v2) -> v1 + v2);
                if ( number < MAX_ALL_FACTORS ) {
                    allFactors.put(number, factors);
                }
                return factors;
            }
        }
        if ( prime ) {
            factors.put(number, 1L);
            if ( number < MAX_ALL_FACTORS ) {
                allFactors.put(number, factors);
            }
        }
        return factors;
    }

}
