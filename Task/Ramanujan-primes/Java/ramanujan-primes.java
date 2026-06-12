import java.util.Arrays;

public class RamanujanPrimes {
    public static void main(String[] args) {
        long start = System.nanoTime();
        System.out.println("First 100 Ramanujan primes:");
        PrimeCounter pc = new PrimeCounter(1 + ramanujanMax(100000));
        for (int i = 1; i <= 100; ++i) {
            int p = ramanujanPrime(pc, i);
            System.out.printf("%,5d%c", p, i % 10 == 0 ? '\n' : ' ');
        }
        System.out.println();
        for (int i = 1000; i <= 100000; i *= 10) {
            int p = ramanujanPrime(pc, i);
            System.out.printf("The %,dth Ramanujan prime is %,d.\n", i, p);
        }
        long end = System.nanoTime();
        System.out.printf("\nElapsed time: %.1f milliseconds\n", (end - start) / 1e6);
    }

    private static int ramanujanMax(int n) {
        return (int)Math.ceil(4 * n * Math.log(4 * n));
    }

    private static int ramanujanPrime(PrimeCounter pc, int n) {
        for (int i = ramanujanMax(n); i >= 0; --i) {
            if (pc.primeCount(i) - pc.primeCount(i / 2) < n)
                return i + 1;
        }
        return 0;
    }

    private static class PrimeCounter {
        private PrimeCounter(int limit) {
            count = new int[limit];
            Arrays.fill(count, 1);
            if (limit > 0)
                count[0] = 0;
            if (limit > 1)
                count[1] = 0;
            for (int i = 4; i < limit; i += 2)
                count[i] = 0;
            for (int p = 3, sq = 9; sq < limit; p += 2) {
                if (count[p] != 0) {
                    for (int q = sq; q < limit; q += p << 1)
                        count[q] = 0;
                }
                sq += (p + 1) << 2;
            }
            Arrays.parallelPrefix(count, (x, y) -> x + y);
        }

        private int primeCount(int n) {
            return n < 1 ? 0 : count[n];
        }

        private int[] count;
    }
}
