public class XorShiftStar {
    private static final long MAGIC = Long.parseUnsignedLong("2545F4914F6CDD1D", 16);
    private long state;

    public void seed(long num) {
        state = num;
    }

    public int nextInt() {
        long x;
        int answer;

        x = state;
        x = x ^ (x >>> 12);
        x = x ^ (x << 25);
        x = x ^ (x >>> 27);
        state = x;
        answer = (int) ((x * MAGIC) >> 32);

        return answer;
    }

    public float nextFloat() {
        return (float) Integer.toUnsignedLong(nextInt()) / (1L << 32);
    }

    public static void main(String[] args) {
        var rng = new XorShiftStar();
        rng.seed(1234567);
        System.out.println(Integer.toUnsignedString(rng.nextInt()));
        System.out.println(Integer.toUnsignedString(rng.nextInt()));
        System.out.println(Integer.toUnsignedString(rng.nextInt()));
        System.out.println(Integer.toUnsignedString(rng.nextInt()));
        System.out.println(Integer.toUnsignedString(rng.nextInt()));
        System.out.println();

        int[] counts = {0, 0, 0, 0, 0};
        rng.seed(987654321);
        for (int i = 0; i < 100_000; i++) {
            int j = (int) Math.floor(rng.nextFloat() * 5.0);
            counts[j]++;
        }
        for (int i = 0; i < counts.length; i++) {
            System.out.printf("%d: %d\n", i, counts[i]);
        }
    }
}
