public class ExtraPrimes {
    private static int nextPrimeDigitNumber(int n) {
        if (n == 0) {
            return 2;
        }
        switch (n % 10) {
            case 2:
                return n + 1;
            case 3:
            case 5:
                return n + 2;
            default:
                return 2 + nextPrimeDigitNumber(n / 10) * 10;
        }
    }

    private static boolean isPrime(int n) {
        if (n < 2) {
            return false;
        }
        if ((n & 1) == 0) {
            return n == 2;
        }
        if (n % 3 == 0) {
            return n == 3;
        }
        if (n % 5 == 0) {
            return n == 5;
        }

        int[] wheel = new int[]{4, 2, 4, 2, 4, 6, 2, 6};
        int p = 7;
        while (true) {
            for (int w : wheel) {
                if (p * p > n) {
                    return true;
                }
                if (n % p == 0) {
                    return false;
                }
                p += w;
            }
        }
    }

    private static int digitSum(int n) {
        int sum = 0;
        for (; n > 0; n /= 10) {
            sum += n % 10;
        }
        return sum;
    }

    public static void main(String[] args) {
        final int limit = 10_000;
        int p = 0, n = 0;

        System.out.printf("Extra primes under %d:\n", limit);
        while (p < limit) {
            p = nextPrimeDigitNumber(p);
            if (isPrime(p) && isPrime(digitSum(p))) {
                n++;
                System.out.printf("%2d: %d\n", n, p);
            }
        }
        System.out.println();
    }
}
