import java.util.*;

public class ErdosSelfridge {
    private int[] primes;
    private int[] category;

    public static void main(String[] args) {
        ErdosSelfridge es = new ErdosSelfridge(1000000);

        System.out.println("First 200 primes:");
        for (var e : es.getPrimesByCategory(200).entrySet()) {
            int category = e.getKey();
            List<Integer> primes = e.getValue();
            System.out.printf("Category %d:\n", category);
            for (int i = 0, n = primes.size(); i != n; ++i)
                System.out.printf("%4d%c", primes.get(i), (i + 1) % 15 == 0 ? '\n' : ' ');
            System.out.printf("\n\n");
        }

        System.out.println("First 1,000,000 primes:");
        for (var e : es.getPrimesByCategory(1000000).entrySet()) {
            int category = e.getKey();
            List<Integer> primes = e.getValue();
            System.out.printf("Category %2d: first = %7d  last = %8d  count = %d\n", category,
                              primes.get(0), primes.get(primes.size() - 1), primes.size());
        }
    }

    private ErdosSelfridge(int limit) {
        PrimeGenerator primeGen = new PrimeGenerator(100000, 200000);
        List<Integer> primeList = new ArrayList<>();
        for (int i = 0; i < limit; ++i)
            primeList.add(primeGen.nextPrime());
        primes = new int[primeList.size()];
        for (int i = 0; i < primes.length; ++i)
            primes[i] = primeList.get(i);
        category = new int[primes.length];
    }

    private Map<Integer, List<Integer>> getPrimesByCategory(int limit) {
        Map<Integer, List<Integer>> result = new TreeMap<>();
        for (int i = 0; i < limit; ++i) {
            var p = result.computeIfAbsent(getCategory(i), k -> new ArrayList<Integer>());
            p.add(primes[i]);
        }
        return result;
    }

    private int getCategory(int index) {
        if (category[index] != 0)
            return category[index];
        int maxCategory = 0;
        int n = primes[index] + 1;
        for (int i = 0; n > 1; ++i) {
            int p = primes[i];
            if (p * p > n)
                break;
            int count = 0;
            for (; n % p == 0; ++count)
                n /= p;
            if (count != 0) {
                int category = (p <= 3) ? 1 : 1 + getCategory(i);
                maxCategory = Math.max(maxCategory, category);
            }
        }
        if (n > 1) {
            int category = (n <= 3) ? 1 : 1 + getCategory(getIndex(n));
            maxCategory = Math.max(maxCategory, category);
        }
        category[index] = maxCategory;
        return maxCategory;
    }

    private int getIndex(int prime) {
       return Arrays.binarySearch(primes, prime);
    }
}
