public class EqualRisesFalls {
    public static void main(String[] args) {
        final int limit1 = 200;
        final int limit2 = 10000000;
        System.out.printf("The first %d numbers in the sequence are:\n", limit1);
        int n = 0;
        for (int count = 0; count < limit2; ) {
            if (equalRisesAndFalls(++n)) {
                ++count;
                if (count <= limit1)
                    System.out.printf("%3d%c", n, count % 20 == 0 ? '\n' : ' ');
            }
        }
        System.out.printf("\nThe %dth number in the sequence is %d.\n", limit2, n);
    }

    private static boolean equalRisesAndFalls(int n) {
        int total = 0;
        for (int previousDigit = -1; n > 0; n /= 10) {
            int digit = n % 10;
            if (previousDigit > digit)
                ++total;
            else if (previousDigit >= 0 && previousDigit < digit)
                --total;
            previousDigit = digit;
        }
        return total == 0;
    }
}
