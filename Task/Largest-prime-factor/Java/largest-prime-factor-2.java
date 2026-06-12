public class App {
    private static final int[] increments = {1, 2, 2, /*cycle start*/ 4, 2, 4, 2, 4, 6, 2, 6};

    public static long largestPrimeFactor(long number) {
        int i = -1;
        for (long d = 2; d * d <= number; d += increments[i = (i + 1 < increments.length? (i + 1) : 3)])
            while (number % d == 0) number /= d;
        return number;
    }

    public static void main(String[] args) {
        long number = 600851475143L;
        System.out.printf("The largest prime factor of %d is %d%n", number, largestPrimeFactor(number));
    }
}
