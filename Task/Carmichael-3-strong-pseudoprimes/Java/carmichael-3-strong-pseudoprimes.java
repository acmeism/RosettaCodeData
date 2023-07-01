public class Test {

    static int mod(int n, int m) {
        return ((n % m) + m) % m;
    }

    static boolean isPrime(int n) {
        if (n == 2 || n == 3)
            return true;
        else if (n < 2 || n % 2 == 0 || n % 3 == 0)
            return false;
        for (int div = 5, inc = 2; Math.pow(div, 2) <= n;
                div += inc, inc = 6 - inc)
            if (n % div == 0)
                return false;
        return true;
    }

    public static void main(String[] args) {
        for (int p = 2; p < 62; p++) {
            if (!isPrime(p))
                continue;
            for (int h3 = 2; h3 < p; h3++) {
                int g = h3 + p;
                for (int d = 1; d < g; d++) {
                    if ((g * (p - 1)) % d != 0 || mod(-p * p, h3) != d % h3)
                        continue;
                    int q = 1 + (p - 1) * g / d;
                    if (!isPrime(q))
                        continue;
                    int r = 1 + (p * q / h3);
                    if (!isPrime(r) || (q * r) % (p - 1) != 1)
                        continue;
                    System.out.printf("%d x %d x %d%n", p, q, r);
                }
            }
        }
    }
}
