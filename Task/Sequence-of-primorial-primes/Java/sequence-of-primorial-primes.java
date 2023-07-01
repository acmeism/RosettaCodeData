import java.math.BigInteger;

public class PrimorialPrimes {

    final static int sieveLimit = 1550_000;
    static boolean[] notPrime = sieve(sieveLimit);

    public static void main(String[] args) {

        int count = 0;
        for (int i = 1; i < 1000_000 && count < 20; i++) {
            BigInteger b = primorial(i);
            if (b.add(BigInteger.ONE).isProbablePrime(1)
                    || b.subtract(BigInteger.ONE).isProbablePrime(1)) {
                System.out.printf("%d ", i);
                count++;
            }
        }
    }

    static BigInteger primorial(int n) {
        if (n == 0)
            return BigInteger.ONE;

        BigInteger result = BigInteger.ONE;
        for (int i = 0; i < sieveLimit && n > 0; i++) {
            if (notPrime[i])
                continue;
            result = result.multiply(BigInteger.valueOf(i));
            n--;
        }
        return result;
    }

    public static boolean[] sieve(int limit) {
        boolean[] composite = new boolean[limit];
        composite[0] = composite[1] = true;

        int max = (int) Math.sqrt(limit);
        for (int n = 2; n <= max; n++) {
            if (!composite[n]) {
                for (int k = n * n; k < limit; k += n) {
                    composite[k] = true;
                }
            }
        }
        return composite;
    }
}
