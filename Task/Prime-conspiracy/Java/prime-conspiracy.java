public class PrimeConspiracy {

    public static void main(String[] args) {
        final int limit = 1000_000;
        final int sieveLimit = 15_500_000;

        int[][] buckets = new int[10][10];
        int prevDigit = 2;
        boolean[] notPrime = sieve(sieveLimit);

        for (int n = 3, primeCount = 1; primeCount < limit; n++) {
            if (notPrime[n])
                continue;

            int digit = n % 10;
            buckets[prevDigit][digit]++;
            prevDigit = digit;
            primeCount++;
        }

        for (int i = 0; i < 10; i++) {
            for (int j = 0; j < 10; j++) {
                if (buckets[i][j] != 0) {
                    System.out.printf("%d -> %d : %2f%n", i,
                            j, buckets[i][j] / (limit / 100.0));
                }
            }
        }
    }

    public static boolean[] sieve(int limit) {
        boolean[] composite = new boolean[limit];
        composite[0] = composite[1] = true;

        int max = (int) Math.sqrt(limit);
        for (int n = 2; n <= max; n++) {
            if (!composite[n]) {
                for (int k = n * n; k < limit; k += n) {
                    composite[k] = true;
                }
            }
        }
        return composite;
    }
}
