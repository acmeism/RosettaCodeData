import java.util.*;
import java.io.*;

public class UntouchableNumbers {

    static int sumDivisors(int n) {
        int sum = 1;
        int k = 2;
        if (n % 2 == 0) {
            k = 1;
        }
        for (int i = 1 + k; (long) i * i <= n; i += k) {
            if (n % i == 0) {
                sum += i;
                int j = n / i;
                if (j != i) {
                    sum += j;
                }
            }
        }
        return sum;
    }

    // Marks as true the integers that appear as a proper-divisor sum of some i (6..n+1).
    static boolean[] sieve(int n) {
        int m = n + 1;                      // mirror the Go code's n++ trick
        boolean[] s = new boolean[m + 1];   // all false by default
        for (int i = 6; i <= m; i++) {
            int sd = sumDivisors(i);
            if (sd <= m) {
                s[sd] = true;
            }
        }
        return s;
    }

    // True = composite, False = prime (like the Go version)
    static boolean[] primeSieve(int limit) {
        int lim = limit + 1;
        boolean[] c = new boolean[lim];
        c[0] = true;
        c[1] = true;
        int p = 3;
        while (true) {
            long p2 = (long) p * p;
            if (p2 >= lim) break;
            for (int i = (int) p2; i < lim; i += 2 * p) {
                c[i] = true;
            }
            while (true) {
                p += 2;
                if (p >= lim || !c[p]) break;
            }
            if (p >= lim) break;
        }
        return c;
    }

    static String commatize(long n) {
        boolean neg = n < 0;
        String s = Long.toString(Math.abs(n));
        StringBuilder sb = new StringBuilder();
        int le = s.length();
        int first = le % 3;
        if (first == 0 && le > 0) first = 3;
        sb.append(s, 0, first);
        for (int i = first; i < le; i += 3) {
            if (sb.length() > 0) sb.append(',');
            sb.append(s, i, i + 3);
        }
        return neg ? "-" + sb : sb.toString();
    }

    public static void main(String[] args) {
        final int limit = 10_000;

        boolean[] composite = primeSieve(limit);
        boolean[] sumsSeen = sieve(63 * limit);

        List<Integer> untouchable = new ArrayList<>();
        untouchable.add(2);
        untouchable.add(5);

        for (int n = 6; n <= limit; n += 2) {
            if (!sumsSeen[n] && composite[n - 1] && composite[n - 3]) {
                untouchable.add(n);
            }
        }

        System.out.println("List of untouchable numbers <= 2,000:");
        int count = 0;
        for (int i = 0; i < untouchable.size() && untouchable.get(i) <= 2000; i++) {
            System.out.printf("%6s", commatize(untouchable.get(i)));
            if ((i + 1) % 10 == 0) System.out.println();
            count++;
        }
        System.out.printf("%n%n%7s untouchable numbers were found  <=     2,000%n", commatize(count));

        int p = 10;
        count = 0;
        for (int n : untouchable) {
            count++;
            if (n > p) {
                System.out.printf("%7s untouchable numbers were found  <= %9s%n",
                        commatize(count - 1), commatize(p));
                p *= 10;
                if (p == limit) break;
            }
        }

        System.out.printf("%7s untouchable numbers were found  <= %s%n",
                commatize(untouchable.size()), commatize(limit));
    }
}
