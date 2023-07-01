public class AksTest {
    private static final long[] c = new long[64];

    public static void main(String[] args) {
        for (int n = 0; n < 10; n++) {
            coeff(n);
            show(n);
        }

        System.out.print("Primes:");
        for (int n = 1; n < c.length; n++)
            if (isPrime(n))
                System.out.printf(" %d", n);

        System.out.println();
    }

    static void coeff(int n) {
        c[0] = 1;
        for (int i = 0; i < n; c[0] = -c[0], i++) {
            c[1 + i] = 1;
            for (int j = i; j > 0; j--)
                c[j] = c[j - 1] - c[j];
        }
    }

    static boolean isPrime(int n) {
        coeff(n);
        c[0]++;
        c[n]--;

        int i = n;
        while (i-- != 0 && c[i] % n == 0)
            continue;
        return i < 0;
    }

    static void show(int n) {
        System.out.print("(x-1)^" + n + " =");
        for (int i = n; i >= 0; i--) {
            System.out.print(" + " + c[i] + "x^" + i);
        }
        System.out.println();
    }
}
