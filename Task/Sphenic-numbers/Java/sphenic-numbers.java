import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;

public class SphenicNumbers {
    public static void main(String[] args) {
        final int limit = 1000000;
        final int imax = limit / 6;
        boolean[] sieve = primeSieve(imax + 1);
        boolean[] sphenic = new boolean[limit + 1];
        for (int i = 0; i <= imax; ++i) {
            if (!sieve[i])
                continue;
            int jmax = Math.min(imax, limit / (i * i));
            if (jmax <= i)
                break;
            for (int j = i + 1; j <= jmax; ++j) {
                if (!sieve[j])
                    continue;
                int p = i * j;
                int kmax = Math.min(imax, limit / p);
                if (kmax <= j)
                    break;
                for (int k = j + 1; k <= kmax; ++k) {
                    if (!sieve[k])
                        continue;
                    assert(p * k <= limit);
                    sphenic[p * k] = true;
                }
            }
        }

        System.out.println("Sphenic numbers < 1000:");
        for (int i = 0, n = 0; i < 1000; ++i) {
            if (!sphenic[i])
                continue;
            ++n;
            System.out.printf("%3d%c", i, n % 15 == 0 ? '\n' : ' ');
        }

        System.out.println("\nSphenic triplets < 10,000:");
        for (int i = 0, n = 0; i < 10000; ++i) {
            if (i > 1 && sphenic[i] && sphenic[i - 1] && sphenic[i - 2]) {
                ++n;
                System.out.printf("(%d, %d, %d)%c",
                                  i - 2, i - 1, i, n % 3 == 0 ? '\n' : ' ');
            }
        }

        int count = 0, triplets = 0, s200000 = 0, t5000 = 0;
        for (int i = 0; i < limit; ++i) {
            if (!sphenic[i])
                continue;
            ++count;
            if (count == 200000)
                s200000 = i;
            if (i > 1 && sphenic[i - 1] && sphenic[i - 2]) {
                ++triplets;
                if (triplets == 5000)
                    t5000 = i;
            }
        }

        System.out.printf("\nNumber of sphenic numbers < 1,000,000: %d\n", count);
        System.out.printf("Number of sphenic triplets < 1,000,000: %d\n", triplets);

        List<Integer> factors = primeFactors(s200000);
        assert(factors.size() == 3);
        System.out.printf("The 200,000th sphenic number: %d = %d * %d * %d\n",
                          s200000, factors.get(0), factors.get(1),
                          factors.get(2));
        System.out.printf("The 5,000th sphenic triplet: (%d, %d, %d)\n",
                          t5000 - 2, t5000 - 1, t5000);
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
        for (int p = 3, sq = 9; sq < limit; p += 2) {
            if (sieve[p]) {
                for (int q = sq; q < limit; q += p << 1)
                    sieve[q] = false;
            }
            sq += (p + 1) << 2;
        }
        return sieve;
    }

    private static List<Integer> primeFactors(int n) {
        List<Integer> factors = new ArrayList<>();
        if (n > 1 && (n & 1) == 0) {
            factors.add(2);
            while ((n & 1) == 0)
                n >>= 1;
        }
        for (int p = 3; p * p <= n; p += 2) {
            if (n % p == 0) {
                factors.add(p);
                while (n % p == 0)
                    n /= p;
            }
        }
        if (n > 1)
            factors.add(n);
        return factors;
    }
}
