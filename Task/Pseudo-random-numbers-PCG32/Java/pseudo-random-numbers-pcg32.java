public class PCG32 {
    private static final long N = 6364136223846793005L;

    private long state = 0x853c49e6748fea9bL;
    private long inc = 0xda3e39cb94b95bdbL;

    public void seed(long seedState, long seedSequence) {
        state = 0;
        inc = (seedSequence << 1) | 1;
        nextInt();
        state = state + seedState;
        nextInt();
    }

    public int nextInt() {
        long old = state;
        state = old * N + inc;
        int shifted = (int) (((old >>> 18) ^ old) >>> 27);
        int rot = (int) (old >>> 59);
        return (shifted >>> rot) | (shifted << ((~rot + 1) & 31));
    }

    public double nextFloat() {
        var u = Integer.toUnsignedLong(nextInt());
        return (double) u / (1L << 32);
    }

    public static void main(String[] args) {
        var r = new PCG32();

        r.seed(42, 54);
        System.out.println(Integer.toUnsignedString(r.nextInt()));
        System.out.println(Integer.toUnsignedString(r.nextInt()));
        System.out.println(Integer.toUnsignedString(r.nextInt()));
        System.out.println(Integer.toUnsignedString(r.nextInt()));
        System.out.println(Integer.toUnsignedString(r.nextInt()));
        System.out.println();

        int[] counts = {0, 0, 0, 0, 0};
        r.seed(987654321, 1);
        for (int i = 0; i < 100_000; i++) {
            int j = (int) Math.floor(r.nextFloat() * 5.0);
            counts[j]++;
        }

        System.out.println("The counts for 100,000 repetitions are:");
        for (int i = 0; i < counts.length; i++) {
            System.out.printf("  %d : %d\n", i, counts[i]);
        }
    }
}
