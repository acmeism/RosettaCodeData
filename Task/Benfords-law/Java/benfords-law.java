import java.math.BigInteger;
import java.util.Locale;

public class BenfordsLaw {

    private static BigInteger[] generateFibonacci(int n) {
        BigInteger[] fib = new BigInteger[n];
        fib[0] = BigInteger.ONE;
        fib[1] = BigInteger.ONE;
        for (int i = 2; i < fib.length; i++) {
            fib[i] = fib[i - 2].add(fib[i - 1]);
        }
        return fib;
    }

    public static void main(String[] args) {
        BigInteger[] numbers = generateFibonacci(1000);

        int[] firstDigits = new int[10];
        for (BigInteger number : numbers) {
            firstDigits[Integer.valueOf(number.toString().substring(0, 1))]++;
        }

        for (int i = 1; i < firstDigits.length; i++) {
            System.out.printf(Locale.ROOT, "%d %10.6f %10.6f%n",
                    i, (double) firstDigits[i] / numbers.length, Math.log10(1.0 + 1.0 / i));
        }
    }
}
