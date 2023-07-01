public class Tau {
    private static long divisorCount(long n) {
        long total = 1;
        // Deal with powers of 2 first
        for (; (n & 1) == 0; n >>= 1) {
            ++total;
        }
        // Odd prime factors up to the square root
        for (long p = 3; p * p <= n; p += 2) {
            long count = 1;
            for (; n % p == 0; n /= p) {
                ++count;
            }
            total *= count;
        }
        // If n > 1 then it's prime
        if (n > 1) {
            total *= 2;
        }
        return total;
    }

    public static void main(String[] args) {
        final long limit = 100;
        System.out.printf("The first %d tau numbers are:%n", limit);
        long count = 0;
        for (long n = 1; count < limit; ++n) {
            if (n % divisorCount(n) == 0) {
                System.out.printf("%6d", n);
                ++count;
                if (count % 10 == 0) {
                    System.out.println();
                }
            }
        }
    }
}
