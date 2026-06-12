class SpecialPrimes {
    private static boolean isPrime(int n) {
        if (n < 2)  return false;
        if (n%2 == 0) return n == 2;
        if (n%3 == 0) return n == 3;
        int d = 5;
        while (d*d <= n) {
            if (n%d == 0) return false;
            d += 2;
            if (n%d == 0) return false;
            d += 4;
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println("Special primes under 1,050:");
        System.out.println("Prime1 Prime2 Gap");
        int lastSpecial = 3;
        int lastGap = 1;
        System.out.printf("%6d %6d %3d\n", 2, 3, lastGap);
        for (int i = 5; i < 1050; i += 2) {
            if (isPrime(i) && (i-lastSpecial) > lastGap) {
                lastGap = i - lastSpecial;
                System.out.printf("%6d %6d %3d\n", lastSpecial, i, lastGap);
                lastSpecial = i;
            }
        }
    }
}
