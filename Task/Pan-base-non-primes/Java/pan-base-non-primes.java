public class PanBaseNonPrimes {
    public static void main(String[] args) {
        System.out.printf("First 50 prime pan-base composites:\n");
        int count = 0;
        for (long n = 2; count < 50; ++n) {
            if (isPanBaseNonPrime(n)) {
                ++count;
                System.out.printf("%3d%c", n, count % 10 == 0 ? '\n' : ' ');
            }
        }

        System.out.printf("\nFirst 20 odd prime pan-base composites:\n");
        count = 0;
        for (long n = 3; count < 20; n += 2) {
            if (isPanBaseNonPrime(n)) {
                ++count;
                System.out.printf("%3d%c", n, count % 10 == 0 ? '\n' : ' ');
            }
        }

        final long limit = 10000;
        count = 0;
        int odd = 0;
        for (long n = 2; n <= limit; ++n) {
            if (isPanBaseNonPrime(n)) {
                ++count;
                if (n % 2 == 1)
                    ++odd;
            }
        }

        System.out.printf("\nCount of pan-base composites up to and including %d: %d\n",
                            limit, count);
        double percent = 100.0 * odd / count;
        System.out.printf("Percent odd  up to and including %d: %f\n",
                            limit, percent);
        System.out.printf("Percent even up to and including %d: %f\n",
                            limit, 100.0 - percent);
    }

    private static boolean isPanBaseNonPrime(long n) {
        if (n < 10)
            return !isPrime(n);
        if (n > 10 && n % 10 == 0)
            return true;
        byte[] d = new byte[20];
        int count = digits(n, d);
        byte max_digit = 0;
        for (int i = 0; i < count; ++i) {
            if (max_digit < d[i])
                max_digit = d[i];
        }
        for (long base = max_digit + 1; base <= n; ++base) {
            if (isPrime(fromDigits(d, count, base)))
                return false;
        }
        return true;
    }

    private static final long[] WHEEL = {4, 2, 4, 2, 4, 6, 2, 6};

    private static boolean isPrime(long n) {
        if (n < 2)
            return false;
        if (n % 2 == 0)
            return n == 2;
        if (n % 3 == 0)
            return n == 3;
        if (n % 5 == 0)
            return n == 5;
        for (long p = 7;;) {
            for (int i = 0; i < 8; ++i) {
                if (p * p > n)
                    return true;
                if (n % p == 0)
                    return false;
                p += WHEEL[i];
            }
        }
    }

    // Compute the digits of n in base 10, least significant digit first.
    private static int digits(long n, byte[] d) {
        int count = 0;
        for (; n > 0 && count < d.length; n /= 10, ++count)
            d[count] = (byte)(n % 10);
        return count;
    }

    // Convert digits in the given base to a number (least significant digit first).
    private static long fromDigits(byte[] a, int count, long base) {
        long n = 0;
        while (count-- > 0)
            n = n * base + a[count];
        return n;
    }
}
