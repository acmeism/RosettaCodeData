import java.util.HashSet;
import java.util.Random;
import java.util.Set;

public class AverageLoopLength {

    private static final int N = 100000;

    //analytical(n) = sum_(i=1)^n (n!/(n-i)!/n**i)
    private static double analytical(int n) {
        double[] factorial = new double[n + 1];
        double[] powers = new double[n + 1];
        powers[0] = 1.0;
        factorial[0] = 1.0;
        for (int i = 1; i <= n; i++) {
            factorial[i] = factorial[i - 1] * i;
            powers[i] = powers[i - 1] * n;
        }
        double sum = 0;
        //memoized factorial and powers
        for (int i = 1; i <= n; i++) {
            sum += factorial[n] / factorial[n - i] / powers[i];
        }
        return sum;
    }

    private static double average(int n) {
        Random rnd = new Random();
        double sum = 0.0;
        for (int a = 0; a < N; a++) {
            int[] random = new int[n];
            for (int i = 0; i < n; i++) {
                random[i] = rnd.nextInt(n);
            }
            Set<Integer> seen = new HashSet<>(n);
            int current = 0;
            int length = 0;
            while (seen.add(current)) {
                length++;
                current = random[current];
            }
            sum += length;
        }
        return sum / N;
    }

    public static void main(String[] args) {
        System.out.println(" N    average    analytical    (error)");
        System.out.println("===  =========  ============  =========");
        for (int i = 1; i <= 20; i++) {
            double avg = average(i);
            double ana = analytical(i);
            System.out.println(String.format("%3d  %9.4f  %12.4f  (%6.2f%%)", i, avg, ana, ((ana - avg) / ana * 100)));
        }
    }
}
