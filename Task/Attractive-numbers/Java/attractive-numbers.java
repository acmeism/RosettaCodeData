public class Attractive {

    static boolean is_prime(int n) {
        if (n < 2) return false;
        if (n % 2 == 0) return n == 2;
        if (n % 3 == 0) return n == 3;
        int d = 5;
        while (d *d <= n) {
            if (n % d == 0) return false;
            d += 2;
            if (n % d == 0) return false;
            d += 4;
        }
        return true;
    }

    static int count_prime_factors(int n) {
        if (n == 1) return 0;
        if (is_prime(n)) return 1;
        int count = 0, f = 2;
        while (true) {
            if (n % f == 0) {
                count++;
                n /= f;
                if (n == 1) return count;
                if (is_prime(n)) f = n;
            }
            else if (f >= 3) f += 2;
            else f = 3;
        }
    }

    public static void main(String[] args) {
        final int max = 120;
        System.out.printf("The attractive numbers up to and including %d are:\n", max);
        for (int i = 1, count = 0; i <= max; ++i) {
            int n = count_prime_factors(i);
            if (is_prime(n)) {
                System.out.printf("%4d", i);
                if (++count % 20 == 0) System.out.println();
            }
        }
        System.out.println();
    }
}
