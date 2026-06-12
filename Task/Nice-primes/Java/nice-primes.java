public class NicePrimes {
    private static boolean isPrime(long n) {
        if (n < 2) {
            return false;
        }
        if (n % 2 == 0L) {
            return n == 2L;
        }
        if (n % 3 == 0L) {
            return n == 3L;
        }

        var p = 5L;
        while (p * p <= n) {
            if (n % p == 0L) {
                return false;
            }
            p += 2;
            if (n % p == 0L) {
                return false;
            }
            p += 4;
        }
        return true;
    }

    private static long digitalRoot(long n) {
        if (n == 0) {
            return 0;
        }
        return 1 + (n - 1) % 9;
    }

    public static void main(String[] args) {
        final long from = 500;
        final long to = 1000;
        int count = 0;

        System.out.printf("Nice primes between %d and %d%n", from, to);
        long n = from;
        while (n < to) {
            if (isPrime(digitalRoot(n)) && isPrime(n)) {
                count++;
                System.out.print(n);
                if (count % 10 == 0) {
                    System.out.println();
                } else {
                    System.out.print(' ');
                }
            }

            n++;
        }
        System.out.println();
        System.out.printf("%d nice primes found.%n", count);
    }
}
