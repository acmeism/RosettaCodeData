import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SuccessivePrimeDifferences {
    private static Integer[] sieve(int limit) {
        List<Integer> primes = new ArrayList<>();
        primes.add(2);
        boolean[] c = new boolean[limit + 1];// composite = true
        // no need to process even numbers > 2
        int p = 3;
        while (true) {
            int p2 = p * p;
            if (p2 > limit) {
                break;
            }
            for (int i = p2; i <= limit; i += 2 * p) {
                c[i] = true;
            }
            do {
                p += 2;
            } while (c[p]);
        }
        for (int i = 3; i <= limit; i += 2) {
            if (!c[i]) {
                primes.add(i);
            }
        }

        return primes.toArray(new Integer[0]);
    }

    private static List<List<Integer>> successivePrimes(Integer[] primes, Integer[] diffs) {
        List<List<Integer>> results = new ArrayList<>();
        int dl = diffs.length;
        outer:
        for (int i = 0; i < primes.length - dl; i++) {
            Integer[] group = new Integer[dl + 1];
            group[0] = primes[i];
            for (int j = i; j < i + dl; ++j) {
                if (primes[j + 1] - primes[j] != diffs[j - i]) {
                    continue outer;
                }
                group[j - i + 1] = primes[j + 1];
            }
            results.add(Arrays.asList(group));
        }
        return results;
    }

    public static void main(String[] args) {
        Integer[] primes = sieve(999999);
        Integer[][] diffsList = {{2}, {1}, {2, 2}, {2, 4}, {4, 2}, {6, 4, 2}};
        System.out.println("For primes less than 1,000,000:-\n");
        for (Integer[] diffs : diffsList) {
            System.out.printf("  For differences of %s ->\n", Arrays.toString(diffs));
            List<List<Integer>> sp = successivePrimes(primes, diffs);
            if (sp.isEmpty()) {
                System.out.println("    No groups found");
                continue;
            }
            System.out.printf("    First group   = %s\n", Arrays.toString(sp.get(0).toArray(new Integer[0])));
            System.out.printf("    Last group    = %s\n", Arrays.toString(sp.get(sp.size() - 1).toArray(new Integer[0])));
            System.out.printf("    Number found  = %d\n", sp.size());
            System.out.println();
        }
    }
}
