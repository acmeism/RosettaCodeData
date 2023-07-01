using System;
using System.Collections.Generic;
using System.Linq;

public static class LongPrimes
{
    public static void Main() {
        var primes = SomePrimeGenerator.Primes(64000).Skip(1).Where(p => Period(p) == p - 1).Append(99999);
        Console.WriteLine(string.Join(" ", primes.TakeWhile(p => p <= 500)));
        int count = 0, limit = 500;
        foreach (int prime in primes) {
            if (prime > limit) {
                Console.WriteLine($"There are {count} long primes below {limit}");
                limit *= 2;
            }
            count++;
        }

        int Period(int n) {
            int r = 1, rr;
            for (int i = 0; i <= n; i++) r = 10 * r % n;
            rr = r;
            for (int period = 1;; period++) {
                r = (10 * r) % n;
                if (r == rr) return period;
            }
        }
    }

}

static class SomePrimeGenerator {

    public static IEnumerable<int> Primes(int lim) {
        bool [] flags = new bool[lim + 1]; int j = 2;
        for (int d = 3, sq = 4; sq <= lim; j++, sq += d += 2)
            if (!flags[j]) {
                yield return j; for (int k = sq; k <= lim; k += j)
                    flags[k] = true;
            }
        for (; j<= lim; j++) if (!flags[j]) yield return j;
    }
}
