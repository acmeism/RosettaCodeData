class Chowla {
    static int chowla(int n) {
        if (n < 1) throw new RuntimeException("argument must be a positive integer")
        int sum = 0
        int i = 2
        while (i * i <= n) {
            if (n % i == 0) {
                int j = (int) (n / i)
                sum += (i == j) ? i : i + j
            }
            i++
        }
        return sum
    }

    static boolean[] sieve(int limit) {
        // True denotes composite, false denotes prime.
        // Only interested in odd numbers >= 3
        boolean[] c = new boolean[limit]
        for (int i = 3; i < limit / 3; i += 2) {
            if (!c[i] && chowla(i) == 0) {
                for (int j = 3 * i; j < limit; j += 2 * i) {
                    c[j] = true
                }
            }
        }
        return c
    }

    static void main(String[] args) {
        for (int i = 1; i <= 37; i++) {
            printf("chowla(%2d) = %d\n", i, chowla(i))
        }
        println()

        int count = 1
        int limit = 10_000_000
        boolean[] c = sieve(limit)
        int power = 100
        for (int i = 3; i < limit; i += 2) {
            if (!c[i]) {
                count++
            }
            if (i == power - 1) {
                printf("Count of primes up to %,10d = %,7d\n", power, count)
                power *= 10
            }
        }
        println()

        count = 0
        limit = 35_000_000
        int i = 2
        while (true) {
            int p = (1 << (i - 1)) * ((1 << i) - 1) // perfect numbers must be of this form
            if (p > limit) break
            if (chowla(p) == p - 1) {
                printf("%,d is a perfect number\n", p)
                count++
            }
            i++
        }
        printf("There are %,d perfect numbers <= %,d\n", count, limit)
    }
}
