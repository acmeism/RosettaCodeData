class CubanPrimes {
    private static int MAX = 1_400_000
    private static boolean[] primes = new boolean[MAX]

    static void main(String[] args) {
        preCompute()
        cubanPrime(200, true)
        for (int i = 1; i <= 5; i++) {
            int max = (int) Math.pow(10, i)
            printf("%,d-th cuban prime = %,d%n", max, cubanPrime(max, false))
        }
    }

    private static long cubanPrime(int n, boolean display) {
        int count = 0
        long result = 0
        for (long i = 0; count < n; i++) {
            long test = 1l + 3 * i * (i + 1)
            if (isPrime(test)) {
                count++
                result = test
                if (display) {
                    printf("%10s%s", String.format("%,d", test), count % 10 == 0 ? "\n" : "")
                }
            }
        }
        return result
    }

    private static boolean isPrime(long n) {
        if (n < MAX) {
            return primes[(int) n]
        }
        int max = (int) Math.sqrt(n)
        for (int i = 3; i <= max; i++) {
            if (primes[i] && n % i == 0) {
                return false
            }
        }
        return true
    }

    private static final void preCompute() {
        //  primes
        for (int i = 2; i < MAX; i++) {
            primes[i] = true
        }
        for (int i = 2; i < MAX; i++) {
            if (primes[i]) {
                for (int j = 2 * i; j < MAX; j += i) {
                    primes[j] = false
                }
            }
        }
    }
}
