public class RhondaNumbers {
    public static void main(String[] args) {
        final int limit = 15;
        for (int base = 2; base <= 36; ++base) {
            if (isPrime(base))
                continue;
            System.out.printf("First %d Rhonda numbers to base %d:\n", limit, base);
            int numbers[] = new int[limit];
            for (int n = 1, count = 0; count < limit; ++n) {
                if (isRhonda(base, n))
                    numbers[count++] = n;
            }
            System.out.printf("In base 10:");
            for (int i = 0; i < limit; ++i)
                System.out.printf(" %d", numbers[i]);
            System.out.printf("\nIn base %d:", base);
            for (int i = 0; i < limit; ++i)
                System.out.printf(" %s", Integer.toString(numbers[i], base));
            System.out.printf("\n\n");
        }
    }

    private static int digitProduct(int base, int n) {
        int product = 1;
        for (; n != 0; n /= base)
            product *= n % base;
        return product;
    }

    private static int primeFactorSum(int n) {
        int sum = 0;
        for (; (n & 1) == 0; n >>= 1)
            sum += 2;
        for (int p = 3; p * p <= n; p += 2)
            for (; n % p == 0; n /= p)
                sum += p;
        if (n > 1)
            sum += n;
        return sum;
    }

    private static boolean isPrime(int n) {
        if (n < 2)
            return false;
        if (n % 2 == 0)
            return n == 2;
        if (n % 3 == 0)
            return n == 3;
        for (int p = 5; p * p <= n; p += 4) {
            if (n % p == 0)
                return false;
            p += 2;
            if (n % p == 0)
                return false;
        }
        return true;
    }

    private static boolean isRhonda(int base, int n) {
        return digitProduct(base, n) == base * primeFactorSum(n);
    }
}
