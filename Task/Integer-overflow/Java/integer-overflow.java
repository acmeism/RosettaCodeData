public class IntegerOverflow {
    public static void main(String[] args) {
        System.out.println("Signed 32-bit:");
        System.out.println(-(-2147483647 - 1));
        System.out.println(2000000000 + 2000000000);
        System.out.println(-2147483647 - 2147483647);
        System.out.println(46341 * 46341);
        System.out.println((-2147483647 - 1) / -1);
        System.out.println("Signed 64-bit:");
        System.out.println(-(-9223372036854775807L - 1));
        System.out.println(5000000000000000000L + 5000000000000000000L);
        System.out.println(-9223372036854775807L - 9223372036854775807L);
        System.out.println(3037000500L * 3037000500L);
        System.out.println((-9223372036854775807L - 1) / -1);
    }
}
