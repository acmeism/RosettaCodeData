public class SafePrimes {
    public static void main(String... args) {
        // Use Sieve of Eratosthenes to find primes
        int SIEVE_SIZE = 10_000_000;
        boolean[] isComposite = new boolean[SIEVE_SIZE];
        // It's really a flag indicating non-prime, but composite usually applies
        isComposite[0] = true;
        isComposite[1] = true;
        for (int n = 2; n < SIEVE_SIZE; n++) {
            if (isComposite[n]) {
                continue;
            }
            for (int i = n * 2; i < SIEVE_SIZE; i += n) {
                isComposite[i] = true;
            }
        }

        int oldSafePrimeCount = 0;
        int oldUnsafePrimeCount = 0;
        int safePrimeCount = 0;
        int unsafePrimeCount = 0;
        StringBuilder safePrimes = new StringBuilder();
        StringBuilder unsafePrimes = new StringBuilder();
        int safePrimesStrCount = 0;
        int unsafePrimesStrCount = 0;
        for (int n = 2; n < SIEVE_SIZE; n++) {
            if (n == 1_000_000) {
                oldSafePrimeCount = safePrimeCount;
                oldUnsafePrimeCount = unsafePrimeCount;
            }
            if (isComposite[n]) {
                continue;
            }
            boolean isUnsafe = isComposite[(n - 1) >>> 1];
            if (isUnsafe) {
                if (unsafePrimeCount < 40) {
                    if (unsafePrimeCount > 0) {
                        unsafePrimes.append(", ");
                    }
                    unsafePrimes.append(n);
                    unsafePrimesStrCount++;
                }
                unsafePrimeCount++;
            }
            else {
                if (safePrimeCount < 35) {
                    if (safePrimeCount > 0) {
                        safePrimes.append(", ");
                    }
                    safePrimes.append(n);
                    safePrimesStrCount++;
                }
                safePrimeCount++;
            }
        }

        System.out.println("First " + safePrimesStrCount + " safe primes: " + safePrimes.toString());
        System.out.println("Number of safe primes below 1,000,000: " + oldSafePrimeCount);
        System.out.println("Number of safe primes below 10,000,000: " + safePrimeCount);
        System.out.println("First " + unsafePrimesStrCount + " unsafe primes: " + unsafePrimes.toString());
        System.out.println("Number of unsafe primes below 1,000,000: " + oldUnsafePrimeCount);
        System.out.println("Number of unsafe primes below 10,000,000: " + unsafePrimeCount);

        return;
    }
}
