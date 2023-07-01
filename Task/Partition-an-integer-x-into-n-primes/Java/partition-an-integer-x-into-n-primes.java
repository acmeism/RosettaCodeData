import java.util.Arrays;
import java.util.stream.IntStream;

public class PartitionInteger {
    private static final int[] primes = IntStream.concat(IntStream.of(2), IntStream.iterate(3, n -> n + 2))
        .filter(PartitionInteger::isPrime)
        .limit(50_000)
        .toArray();

    private static boolean isPrime(int n) {
        if (n < 2) return false;
        if (n % 2 == 0) return n == 2;
        if (n % 3 == 0) return n == 3;
        int d = 5;
        while (d * d <= n) {
            if (n % d == 0) return false;
            d += 2;
            if (n % d == 0) return false;
            d += 4;
        }
        return true;
    }

    private static boolean findCombo(int k, int x, int m, int n, int[] combo) {
        boolean foundCombo = false;
        if (k >= m) {
            if (Arrays.stream(combo).map(i -> primes[i]).sum() == x) {
                String s = m > 1 ? "s" : "";
                System.out.printf("Partitioned %5d with %2d prime%s: ", x, m, s);
                for (int i = 0; i < m; ++i) {
                    System.out.print(primes[combo[i]]);
                    if (i < m - 1) System.out.print('+');
                    else System.out.println();
                }
                foundCombo = true;
            }
        } else {
            for (int j = 0; j < n; ++j) {
                if (k == 0 || j > combo[k - 1]) {
                    combo[k] = j;
                    if (!foundCombo) {
                        foundCombo = findCombo(k + 1, x, m, n, combo);
                    }
                }
            }
        }
        return foundCombo;
    }

    private static void partition(int x, int m) {
        if (x < 2 || m < 1 || m >= x) {
            throw new IllegalArgumentException();
        }
        int[] filteredPrimes = Arrays.stream(primes).filter(it -> it <= x).toArray();
        int n = filteredPrimes.length;
        if (n < m) throw new IllegalArgumentException("Not enough primes");
        int[] combo = new int[m];
        boolean foundCombo = findCombo(0, x, m, n, combo);
        if (!foundCombo) {
            String s = m > 1 ? "s" : " ";
            System.out.printf("Partitioned %5d with %2d prime%s: (not possible)\n", x, m, s);
        }
    }

    public static void main(String[] args) {
        partition(99809, 1);
        partition(18, 2);
        partition(19, 3);
        partition(20, 4);
        partition(2017, 24);
        partition(22699, 1);
        partition(22699, 2);
        partition(22699, 3);
        partition(22699, 4);
        partition(40355, 3);
    }
}
