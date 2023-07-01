public class LoopIncrementWithinBody {

    static final int LIMIT = 42;

    static boolean isPrime(long n) {
        if (n % 2 == 0) return n == 2;
        if (n % 3 == 0) return n == 3;
        long d = 5;
        while (d * d <= n) {
            if (n % d == 0) return false;
            d += 2;
            if (n % d == 0) return false;
            d += 4;
        }
        return true;
    }

    public static void main(String[] args) {
        long i;
        int n;
        for (i = LIMIT, n = 0; n < LIMIT; i++)
            if (isPrime(i)) {
                n++;
                System.out.printf("n = %-2d  %,19d\n", n, i);
                i += i - 1;
            }
    }
}
