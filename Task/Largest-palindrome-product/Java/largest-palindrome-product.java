// Compiled and executed in 48.481 sec(s)




public class PalindromicProduct {
    public static long reverseDigits(long n) {
        long result = 0;
        while (n > 0) {
            result = n % 10 + result * 10;
            n /= 10;
        }
        return result;
    }

    public static void main(String[] args) {
        long power = 10;
        for (int n = 2; n <= 9; ++n) {
            final long low = power * 9;
            power *= 10;
            final long high = power - 1;
            boolean found = false;
            for (long i = high; i >= low && !found; --i) {
                final long j = reverseDigits(i);
                long possibleProduct = i * power + j;
                // 'highCopy' cannot be even nor end in 5 to produce a product ending in 9
                long highCopy = high;
                while (highCopy > low) {
                    if (highCopy % 10 != 5) {
                        final long divisor = possibleProduct / highCopy;
                        if (divisor > high) {
                            break;
                        }
                        if (possibleProduct % highCopy == 0) {
                            System.out.printf("Largest palindromic product of two %d-digit integers: %d x %d = %d%n",
                                              n, highCopy, divisor, possibleProduct);
                            found = true;
                            break;
                        }
                    }
                    highCopy -= 2;
                }
            }
        }
    }
}

