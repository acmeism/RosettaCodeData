class AttractiveNumbers {
    static boolean isPrime(int n) {
        if (n < 2) return false
        if (n % 2 == 0) return n == 2
        if (n % 3 == 0) return n == 3
        int d = 5
        while (d * d <= n) {
            if (n % d == 0) return false
            d += 2
            if (n % d == 0) return false
            d += 4
        }
        return true
    }

    static int countPrimeFactors(int n) {
        if (n == 1) return 0
        if (isPrime(n)) return 1
        int count = 0, f = 2
        while (true) {
            if (n % f == 0) {
                count++
                n /= f
                if (n == 1) return count
                if (isPrime(n)) f = n
            } else if (f >= 3) f += 2
            else f = 3
        }
    }

    static void main(String[] args) {
        final int max = 120
        printf("The attractive numbers up to and including %d are:\n", max)
        int count = 0
        for (int i = 1; i <= max; ++i) {
            int n = countPrimeFactors(i)
            if (isPrime(n)) {
                printf("%4d", i)
                if (++count % 20 == 0) println()
            }
        }
        println()
    }
}
