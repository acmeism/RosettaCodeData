public class Frobenius {
    public static void main(String[] args) {
        final int limit = 1000000;
        System.out.printf("Frobenius numbers less than %d (asterisk marks primes):\n", limit);
        PrimeGenerator primeGen = new PrimeGenerator(1000, 100000);
        int prime1 = primeGen.nextPrime();
        for (int count = 1; ; ++count) {
            int prime2 = primeGen.nextPrime();
            int frobenius = prime1 * prime2 - prime1 - prime2;
            if (frobenius >= limit)
                break;
            System.out.printf("%6d%c%c", frobenius,
                    isPrime(frobenius) ? '*' : ' ',
                    count % 10 == 0 ? '\n' : ' ');
            prime1 = prime2;
        }
        System.out.println();
    }

    private static boolean isPrime(int n) {
        if (n < 2)
            return false;
        if (n % 2 == 0)
            return n == 2;
        if (n % 3 == 0)
            return n == 3;
        for (int p = 5; p * p <= n; p += 4) {
            if (n % p == 0)
                return false;
            p += 2;
            if (n % p == 0)
                return false;
        }
        return true;
    }
}
