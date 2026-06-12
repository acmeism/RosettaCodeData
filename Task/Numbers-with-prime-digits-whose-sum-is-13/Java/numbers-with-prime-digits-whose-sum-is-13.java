public class PrimeDigits {
    private static boolean primeDigitsSum13(int n) {
        int sum = 0;
        while (n > 0) {
            int r = n % 10;
            if (r != 2 && r != 3 && r != 5 && r != 7) {
                return false;
            }
            n /= 10;
            sum += r;
        }
        return sum == 13;
    }

    public static void main(String[] args) {
        // using 2 for all digits, 6 digits is the max prior to over-shooting 13
        int c = 0;
        for (int i = 1; i < 1_000_000; i++) {
            if (primeDigitsSum13(i)) {
                System.out.printf("%6d ", i);
                if (c++ == 10) {
                    c = 0;
                    System.out.println();
                }
            }
        }
        System.out.println();
    }
}
