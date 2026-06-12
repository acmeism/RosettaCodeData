import java.util.*;

public class StrangeUniquePrimeTriplets {
    public static void main(String[] args) {
        strangeUniquePrimeTriplets(30, true);
        strangeUniquePrimeTriplets(1000, false);
    }

    private static void strangeUniquePrimeTriplets(int limit, boolean verbose) {
        boolean[] sieve = primeSieve(limit * 3);
        List<Integer> primeList = new ArrayList<>();
        for (int p = 3; p < limit; p += 2) {
            if (sieve[p])
                primeList.add(p);
        }
        int n = primeList.size();
        // Convert object list to primitive array for performance
        int[] primes = new int[n];
        for (int i = 0; i < n; ++i)
            primes[i] = primeList.get(i);
        int count = 0;
        if (verbose)
            System.out.printf("Strange unique prime triplets < %d:\n", limit);
        for (int i = 0; i + 2 < n; ++i) {
            for (int j = i + 1; j + 1 < n; ++j) {
                int s = primes[i] + primes[j];
                for (int k = j + 1; k < n; ++k) {
                    int sum = s + primes[k];
                    if (sieve[sum]) {
                        ++count;
                        if (verbose)
                            System.out.printf("%2d + %2d + %2d = %2d\n", primes[i], primes[j], primes[k], sum);
                    }
                }
            }
        }
        System.out.printf("\nCount of strange unique prime triplets < %d is %d.\n", limit, count);
    }

    private static boolean[] primeSieve(int limit) {
        boolean[] sieve = new boolean[limit];
        Arrays.fill(sieve, true);
        if (limit > 0)
            sieve[0] = false;
        if (limit > 1)
            sieve[1] = false;
        for (int i = 4; i < limit; i += 2)
            sieve[i] = false;
        for (int p = 3; ; p += 2) {
            int q = p * p;
            if (q >= limit)
                break;
            if (sieve[p]) {
                int inc = 2 * p;
                for (; q < limit; q += inc)
                    sieve[q] = false;
            }
        }
        return sieve;
    }
}
