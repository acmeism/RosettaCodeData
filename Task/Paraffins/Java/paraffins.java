import java.math.BigInteger;
import java.util.Arrays;

class Test {
    final static int nMax = 250;
    final static int nBranches = 4;

    static BigInteger[] rooted = new BigInteger[nMax + 1];
    static BigInteger[] unrooted = new BigInteger[nMax + 1];
    static BigInteger[] c = new BigInteger[nBranches];

    static void tree(int br, int n, int l, int inSum, BigInteger cnt) {
        int sum = inSum;
        for (int b = br + 1; b <= nBranches; b++) {
            sum += n;

            if (sum > nMax || (l * 2 >= sum && b >= nBranches))
                return;

            BigInteger tmp = rooted[n];
            if (b == br + 1) {
                c[br] = tmp.multiply(cnt);
            } else {
                c[br] = c[br].multiply(tmp.add(BigInteger.valueOf(b - br - 1)));
                c[br] = c[br].divide(BigInteger.valueOf(b - br));
            }

            if (l * 2 < sum)
                unrooted[sum] = unrooted[sum].add(c[br]);

            if (b < nBranches)
                rooted[sum] = rooted[sum].add(c[br]);

            for (int m = n - 1; m > 0; m--)
                tree(b, m, l, sum, c[br]);
        }
    }

    static void bicenter(int s) {
        if ((s & 1) == 0) {
            BigInteger tmp = rooted[s / 2];
            tmp = tmp.add(BigInteger.ONE).multiply(rooted[s / 2]);
            unrooted[s] = unrooted[s].add(tmp.shiftRight(1));
        }
    }

    public static void main(String[] args) {
        Arrays.fill(rooted, BigInteger.ZERO);
        Arrays.fill(unrooted, BigInteger.ZERO);
        rooted[0] = rooted[1] = BigInteger.ONE;
        unrooted[0] = unrooted[1] = BigInteger.ONE;

        for (int n = 1; n <= nMax; n++) {
            tree(0, n, n, 1, BigInteger.ONE);
            bicenter(n);
            System.out.printf("%d: %s%n", n, unrooted[n]);
        }
    }
}
