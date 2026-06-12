public class Strange {
    private static final boolean[] p = {
        false, false, true,  true,  false,
        true,  false, true,  false, false,
        false, true,  false, true,  false,
        false, false, true,  false
    };

    public static boolean isstrange(long n) {
        if (n < 10) return false;
        for (; n >= 10; n /= 10) {
            if (!p[(int)(n%10 + (n/10)%10)]) return false;
        }
        return true;
    }

    public static void main(String[] args) {
        long nMin = Long.parseLong(args[0]);
        long nMax = Long.parseLong(args[1]);
        int k = 0;

        for (long n = nMin; n <= nMax; n++) {
            if (isstrange(n)) {
                System.out.print(n + (++k%10 != 0 ? " " : "\n"));
            }
        }
    }
}
