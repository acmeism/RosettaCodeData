public class DivisorSum {
    private static long divisorSum(long n) {
        var total = 1L;
        var power = 2L;
        // Deal with powers of 2 first
        for (; (n & 1) == 0; power <<= 1, n >>= 1) {
            total += power;
        }
        // Odd prime factors up to the square root
        for (long p = 3; p * p <= n; p += 2) {
            long sum = 1;
            for (power = p; n % p == 0; power *= p, n /= p) {
                sum += power;
            }
            total *= sum;
        }
        // If n > 1 then it's prime
        if (n > 1) {
            total *= n + 1;
        }
        return total;
    }

    public static void main(String[] args) {
        final long limit = 100;
        System.out.printf("Sum of divisors for the first %d positive integers:%n", limit);
        for (long n = 1; n <= limit; ++n) {
            System.out.printf("%4d", divisorSum(n));
            if (n % 10 == 0) {
                System.out.println();
            }
        }
    }
}
