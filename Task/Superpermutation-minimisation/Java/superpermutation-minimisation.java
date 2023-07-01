import static java.util.stream.IntStream.rangeClosed;

public class Test {
    final static int nMax = 12;

    static char[] superperm;
    static int pos;
    static int[] count = new int[nMax];

    static int factSum(int n) {
        return rangeClosed(1, n)
                .map(m -> rangeClosed(1, m).reduce(1, (a, b) -> a * b)).sum();
    }

    static boolean r(int n) {
        if (n == 0)
            return false;

        char c = superperm[pos - n];
        if (--count[n] == 0) {
            count[n] = n;
            if (!r(n - 1))
                return false;
        }
        superperm[pos++] = c;
        return true;
    }

    static void superPerm(int n) {
        String chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        pos = n;
        superperm = new char[factSum(n)];

        for (int i = 0; i < n + 1; i++)
            count[i] = i;
        for (int i = 1; i < n + 1; i++)
            superperm[i - 1] = chars.charAt(i);

        while (r(n)) {
        }
    }

    public static void main(String[] args) {
        for (int n = 0; n < nMax; n++) {
            superPerm(n);
            System.out.printf("superPerm(%2d) len = %d", n, superperm.length);
            System.out.println();
        }
    }
}
