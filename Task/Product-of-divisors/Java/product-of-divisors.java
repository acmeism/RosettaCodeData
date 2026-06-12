public class ProductOfDivisors {
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

    private static long divisorProduct(long n) {
        return (long) Math.pow(n, divisorCount(n) / 2.0);
    }

    public static void main(String[] args) {
        final long limit = 50;
        System.out.printf("Product of divisors for the first %d positive integers:%n", limit);
        for (long n = 1; n <= limit; n++) {
            System.out.printf("%11d", divisorProduct(n));
            if (n % 5 == 0) {
                System.out.println();
            }
        }
    }
}
