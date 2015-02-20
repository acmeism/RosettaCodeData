import java.util.stream.IntStream;

public class IteratedDigitsSquaring {

    public static void main(String[] args) {
        long r = IntStream.range(1, 100_000_000)
                .parallel()
                .filter(n -> calc(n) == 89)
                .count();
        System.out.println(r);
    }

    private static int calc(int n) {
        while (n != 89 && n != 1) {
            int total = 0;
            while (n > 0) {
                total += Math.pow(n % 10, 2);
                n /= 10;
            }
            n = total;
        }
        return n;
    }
}
