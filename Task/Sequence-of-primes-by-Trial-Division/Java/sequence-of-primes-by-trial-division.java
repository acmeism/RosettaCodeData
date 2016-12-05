import java.util.stream.IntStream;

public class Test {

    static IntStream getPrimes(int start, int end) {
        return IntStream.rangeClosed(start, end).filter(n -> isPrime(n));
    }

    public static boolean isPrime(long x) {
        if (x < 3 || x % 2 == 0)
            return x == 2;

        long max = (long) Math.sqrt(x);
        for (long n = 3; n <= max; n += 2) {
            if (x % n == 0) {
                return false;
            }
        }
        return true;
    }

    public static void main(String[] args) {
        getPrimes(0, 100).forEach(p -> System.out.printf("%d, ", p));
    }
}
