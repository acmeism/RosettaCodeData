import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class CalmoSoftPrimes {
    public static void main(String[] args) {
        PrimeGenerator primeGen = new PrimeGenerator(100000, 250000);
        List<Integer> primes = new ArrayList<>();
        final int[] limits = {100, 5000, 10000, 500000, 50000000};
        long total = 0;
        int last = 0;
        int prime = primeGen.nextPrime();
        for (int limit : limits) {
            do {
                primes.add(prime);
                total += prime;
                ++last;
                prime = primeGen.nextPrime();
            } while (prime < limit);
            long sum = total;
            int longest = 1;
            List<Integer> starts = new ArrayList<>();
            for (int start = 0; start <= last - longest; ++start) {
                long s = sum;
                for (int finish = last; finish-- >= start + longest;) {
                    if (isPrime(s)) {
                        int length = finish - start + 1;
                        if (length > longest) {
                            longest = length;
                            starts.clear();
                        }
                        starts.add(start);
                    }
                    s -= primes.get(finish);
                }
                sum -= primes.get(start);
            }
            System.out.printf("For primes up to %d:\nThe following sequence%s of %d consecutive primes yield%s a prime sum:\n",
                              limit, starts.size() == 1 ? "" : "s", longest, starts.size() == 1 ? "s" : "");
            for (int i = 0; i < starts.size(); ++i) {
                int start = starts.get(i);
                sum = 0;
                for (int j = start; j < start + longest; ++j)
                    sum += primes.get(j);
                final String separator = " + ";
                if (longest > 12) {
                    System.out.print(join(separator, primes.subList(start, start + 6))
                        + separator + "..." + separator
                        + join(separator, primes.subList(start + longest - 6, start + longest)));
                } else {
                    System.out.print(join(separator, primes.subList(start, start + longest)));
                }
                System.out.println(" = " + sum);
            }
            System.out.println();
        }
    }

    private static <T> String join(String separator, List<T> list) {
        return list.stream().map(Object::toString).collect(Collectors.joining(separator));
    }

    private static boolean isPrime(long n) {
        if (n < 2)
            return false;
        if (n % 2 == 0)
            return n == 2;
        if (n % 3 == 0)
            return n == 3;
        for (long p = 5; p * p <= n; p += 4) {
            if (n % p == 0)
                return false;
            p += 2;
            if (n % p == 0)
                return false;
        }
        return true;
    }
}
