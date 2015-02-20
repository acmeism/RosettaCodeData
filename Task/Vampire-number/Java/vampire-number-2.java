public class VampireNumber {

    public static void main(String args[]) {

        // scan only the ranges that have an even number of digits
        // for instance: 10 .. 99, 1000 .. 9999 etc
        long countVamps = 0, start = 10, tens = 10;
        outer:
        for (int numDigits = 2; numDigits <= 18; numDigits += 2) {
            long end = start * 10;
            for (long i = start; i < end; i++) {
                if (countFangs(i, tens) > 0) {
                    if (++countVamps >= 26)
                        break outer;
                }
            }
            start *= 100;
            tens *= 10;
        }
        System.out.println();

        long[] bigs = {16758243290880L, 24959017348650L,
            14593825548650L};

        for (long b : bigs)
            countFangs(b, 10000000L);
    }

    private static int countFangs(long n, long tens) {
        int countFangs = 0;

        // limit the search space for factors (as in C example)
        long lo = Math.max(tens / 10, (n + tens - 2) / (tens - 1));
        long hi = Math.min(n / lo, (long) Math.sqrt(n));

        long nTally = tallyDigits(n);

        for (long a = lo; a <= hi; a++) {
            long b = n / a;

            if (a * b != n)
                continue;

            // check for mod 9 congruence
            if (n % 9 != (a + b) % 9)
                continue;

            if (a % 10 == 0 && b % 10 == 0)
                continue;

            if (nTally == tallyDigits(a) + tallyDigits(b)) {
                if (countFangs == 0)
                    System.out.printf("\n%d : ", n);
                System.out.printf("[%d, %d]", a, b);
                countFangs++;
            }
        }
        return countFangs;
    }

    // sum to a unique number to represent set of digits (as in C example)
    private static long tallyDigits(long n) {
        long total = 0;
        while (n > 0) {
            total += 1L << ((n % 10) * 6);
            n /= 10;
        }
        return total;
    }
}
