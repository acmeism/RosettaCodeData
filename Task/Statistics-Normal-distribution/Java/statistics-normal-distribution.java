import static java.lang.Math.*;
import static java.util.Arrays.stream;
import java.util.Locale;
import java.util.function.DoubleSupplier;
import static java.util.stream.Collectors.joining;
import java.util.stream.DoubleStream;
import static java.util.stream.IntStream.range;

public class Test implements DoubleSupplier {

    private double mu, sigma;
    private double[] state = new double[2];
    private int index = state.length;

    Test(double m, double s) {
        mu = m;
        sigma = s;
    }

    static double[] meanStdDev(double[] numbers) {
        if (numbers.length == 0)
            return new double[]{0.0, 0.0};

        double sx = 0.0, sxx = 0.0;
        long n = 0;
        for (double x : numbers) {
            sx += x;
            sxx += pow(x, 2);
            n++;
        }

        return new double[]{sx / n, pow((n * sxx - pow(sx, 2)), 0.5) / n};
    }

    static String replicate(int n, String s) {
        return range(0, n + 1).mapToObj(i -> s).collect(joining());
    }

    static void showHistogram01(double[] numbers) {
        final int maxWidth = 50;
        long[] bins = new long[10];

        for (double x : numbers)
            bins[(int) (x * bins.length)]++;

        double maxFreq = stream(bins).max().getAsLong();

        for (int i = 0; i < bins.length; i++)
            System.out.printf(" %3.1f: %s%n", i / (double) bins.length,
                    replicate((int) (bins[i] / maxFreq * maxWidth), "*"));
        System.out.println();
    }

    @Override
    public double getAsDouble() {
        index++;
        if (index >= state.length) {
            double r = sqrt(-2 * log(random())) * sigma;
            double x = 2 * PI * random();
            state = new double[]{mu + r * sin(x), mu + r * cos(x)};
            index = 0;
        }
        return state[index];

    }

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        double[] data = DoubleStream.generate(new Test(0.0, 0.5)).limit(100_000)
                .toArray();

        double[] res = meanStdDev(data);
        System.out.printf("Mean: %8.6f, SD: %8.6f%n", res[0], res[1]);

        showHistogram01(stream(data).map(a -> max(0.0, min(0.9999, a / 3 + 0.5)))
                .toArray());
    }
}
