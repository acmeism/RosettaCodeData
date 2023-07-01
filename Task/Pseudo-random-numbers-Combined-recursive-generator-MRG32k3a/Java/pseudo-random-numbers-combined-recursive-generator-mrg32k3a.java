public class App {
    private static long mod(long x, long y) {
        long m = x % y;
        if (m < 0) {
            if (y < 0) {
                return m - y;
            } else {
                return m + y;
            }
        }
        return m;
    }

    public static class RNG {
        // first generator
        private final long[] a1 = {0, 1403580, -810728};
        private static final long m1 = (1L << 32) - 209;
        private long[] x1;
        // second generator
        private final long[] a2 = {527612, 0, -1370589};
        private static final long m2 = (1L << 32) - 22853;
        private long[] x2;
        // other
        private static final long d = m1 + 1;

        public void seed(long state) {
            x1 = new long[]{state, 0, 0};
            x2 = new long[]{state, 0, 0};
        }

        public long nextInt() {
            long x1i = mod(a1[0] * x1[0] + a1[1] * x1[1] + a1[2] * x1[2], m1);
            long x2i = mod(a2[0] * x2[0] + a2[1] * x2[1] + a2[2] * x2[2], m2);
            long z = mod(x1i - x2i, m1);

            // keep the last three values of the first generator
            x1 = new long[]{x1i, x1[0], x1[1]};
            // keep the last three values of the second generator
            x2 = new long[]{x2i, x2[0], x2[1]};

            return z + 1;
        }

        public double nextFloat() {
            return 1.0 * nextInt() / d;
        }
    }

    public static void main(String[] args) {
        RNG rng = new RNG();

        rng.seed(1234567);
        System.out.println(rng.nextInt());
        System.out.println(rng.nextInt());
        System.out.println(rng.nextInt());
        System.out.println(rng.nextInt());
        System.out.println(rng.nextInt());
        System.out.println();

        int[] counts = {0, 0, 0, 0, 0};
        rng.seed(987654321);
        for (int i = 0; i < 100_000; i++) {
            int value = (int) Math.floor(rng.nextFloat() * 5.0);
            counts[value]++;
        }
        for (int i = 0; i < counts.length; i++) {
            System.out.printf("%d: %d%n", i, counts[i]);
        }
    }
}
