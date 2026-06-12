import java.util.*;

public class PracticalNumbers {
    public static void main(String[] args) {
        final int from = 1;
        final int to = 333;
        List<Integer> practical = new ArrayList<>();
        for (int i = from; i <= to; ++i) {
            if (isPractical(i))
                practical.add(i);
        }
        System.out.printf("Found %d practical numbers between %d and %d:\n%s\n",
                practical.size(), from, to, shorten(practical, 10));

        printPractical(666);
        printPractical(6666);
        printPractical(66666);
        printPractical(672);
        printPractical(720);
        printPractical(222222);
    }

    private static void printPractical(int n) {
        if (isPractical(n))
            System.out.printf("%d is a practical number.\n", n);
        else
            System.out.printf("%d is not a practical number.\n", n);
    }

    private static boolean isPractical(int n) {
        int[] divisors = properDivisors(n);
        for (int i = 1; i < n; ++i) {
            if (!sumOfAnySubset(i, divisors, divisors.length))
                return false;
        }
        return true;
    }

    private static boolean sumOfAnySubset(int n, int[] f, int len) {
        if (len == 0)
            return false;
        int total = 0;
        for (int i = 0; i < len; ++i) {
            if (n == f[i])
                return true;
            total += f[i];
        }
        if (n == total)
            return true;
        if (n > total)
            return false;
        --len;
        int d = n - f[len];
        return (d > 0 && sumOfAnySubset(d, f, len)) || sumOfAnySubset(n, f, len);
    }

    private static int[] properDivisors(int n) {
        List<Integer> divisors = new ArrayList<>();
        divisors.add(1);
        for (int i = 2;; ++i) {
            int i2 = i * i;
            if (i2 > n)
                break;
            if (n % i == 0) {
                divisors.add(i);
                if (i2 != n)
                    divisors.add(n / i);
            }
        }
        int[] result = new int[divisors.size()];
        for (int i = 0; i < result.length; ++i)
            result[i] = divisors.get(i);
        Arrays.sort(result);
        return result;
    }

    private static String shorten(List<Integer> list, int n) {
        StringBuilder str = new StringBuilder();
        int len = list.size(), i = 0;
        if (n > 0 && len > 0)
            str.append(list.get(i++));
        for (; i < n && i < len; ++i) {
            str.append(", ");
            str.append(list.get(i));
        }
        if (len > i + n) {
            if (n > 0)
                str.append(", ...");
            i = len - n;
        }
        for (; i < len; ++i) {
            str.append(", ");
            str.append(list.get(i));
        }
        return str.toString();
    }
}
