import java.util.*;

public class PermutedMultiples {
    public static void main(String[] args) {
        for (int p = 100; ; p *= 10) {
            int max = (p * 10) / 6;
            for (int n = p + 2; n <= max; n += 3) {
                if (sameDigits(n)) {
                    System.out.printf(" n = %d\n", n);
                    for (int i = 2; i <= 6; ++i)
                        System.out.printf("%dn = %d\n", i, n * i);
                    return;
                }
            }
        }
    }

    // Returns true if n, 2n, ..., 6n all have the same base 10 digits.
    private static boolean sameDigits(int n) {
        int[] digits = getDigits(n);
        for (int i = 0, m = n; i < 5; ++i) {
            m += n;
            if (!Arrays.equals(getDigits(m), digits))
                return false;
        }
        return true;
    }

    private static int[] getDigits(int n) {
        int[] digits = new int[10];
        do {
            ++digits[n % 10];
            n /= 10;
        } while (n > 0);
        return digits;
    }
}
