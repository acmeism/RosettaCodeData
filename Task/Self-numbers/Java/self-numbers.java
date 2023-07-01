public class SelfNumbers {
    private static final int MC = 103 * 1000 * 10000 + 11 * 9 + 1;
    private static final boolean[] SV = new boolean[MC + 1];

    private static void sieve() {
        int[] dS = new int[10_000];
        for (int a = 9, i = 9999; a >= 0; a--) {
            for (int b = 9; b >= 0; b--) {
                for (int c = 9, s = a + b; c >= 0; c--) {
                    for (int d = 9, t = s + c; d >= 0; d--) {
                        dS[i--] = t + d;
                    }
                }
            }
        }
        for (int a = 0, n = 0; a < 103; a++) {
            for (int b = 0, d = dS[a]; b < 1000; b++, n += 10000) {
                for (int c = 0, s = d + dS[b] + n; c < 10000; c++) {
                    SV[dS[c] + s++] = true;
                }
            }
        }
    }

    public static void main(String[] args) {
        sieve();
        System.out.println("The first 50 self numbers are:");
        for (int i = 0, count = 0; count <= 50; i++) {
            if (!SV[i]) {
                count++;
                if (count <= 50) {
                    System.out.printf("%d ", i);
                } else {
                    System.out.printf("%n%n       Index     Self number%n");
                }
            }
        }
        for (int i = 0, limit = 1, count = 0; i < MC; i++) {
            if (!SV[i]) {
                if (++count == limit) {
                    System.out.printf("%,12d   %,13d%n", count, i);
                    limit *= 10;
                }
            }
        }
    }
}
