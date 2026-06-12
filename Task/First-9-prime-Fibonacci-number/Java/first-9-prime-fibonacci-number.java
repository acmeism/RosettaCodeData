import java.math.BigInteger;

public class PrimeFibonacciGenerator {
    private PrimeGenerator primeGen = new PrimeGenerator(10000, 200000);
    private BigInteger f0 = BigInteger.ZERO;
    private BigInteger f1 = BigInteger.ONE;
    private int index = 0;

    public static void main(String[] args) {
        PrimeFibonacciGenerator gen = new PrimeFibonacciGenerator();
        long start = System.currentTimeMillis();
        for (int i = 1; i <= 26; ++i) {
            BigInteger f = gen.next();
            System.out.printf("%d: F(%d) = %s\n", i, gen.index - 1, toString(f));
        }
        long finish = System.currentTimeMillis();
        System.out.printf("elapsed time: %g seconds\n", (finish - start)/1000.0);
    }

    private PrimeFibonacciGenerator() {
        for (int i = 0; i < 2; ++i)
            primeGen.nextPrime();
    }

    private BigInteger next() {
        for (;;) {
            if (index > 4) {
                int p = primeGen.nextPrime();
                for (; p > index; ++index)
                    nextFibonacci();
            }
            ++index;
            BigInteger f = nextFibonacci();
            if (f.isProbablePrime(30))
                return f;
        }
    }

    private BigInteger nextFibonacci() {
        BigInteger result = f0;
        BigInteger f = f0.add(f1);
        f0 = f1;
        f1 = f;
        return result;
    }

    private static String toString(BigInteger f) {
        String str = f.toString();
        if (str.length() > 40) {
            StringBuilder s = new StringBuilder(str.substring(0, 20));
            s.append("...");
            s.append(str.substring(str.length() - 20));
            s.append(" (");
            s.append(str.length());
            s.append(" digits)");
            str = s.toString();
        }
        return str;
    }
}
