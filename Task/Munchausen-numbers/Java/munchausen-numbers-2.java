public class Munchhausen {

    static final long[] cache = new long[10];

    public static void main(String[] args) {
        // Allowing 0 ^ 0 to be 0
        for (int i = 1; i < 10; i++) {
            cache[i] = (long) Math.pow(i, i);
        }
        for (long i = 0L; i <= 500_000_000L; i++) {
            if (isMunchhausen(i)) {
                System.out.println(i);
            }
        }
    }

    private static boolean isMunchhausen(long n) {
        long sum = 0, nn = n;
        do {
            sum += cache[(int)(nn % 10)];
            if (sum > n) {
                return false;
            }
            nn /= 10;
        } while (nn > 0);

        return sum == n;
    }
}
