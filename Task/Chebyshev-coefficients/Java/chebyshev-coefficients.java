import static java.lang.Math.*;
import java.util.function.Function;

public class ChebyshevCoefficients {

    static double map(double x, double min_x, double max_x, double min_to,
            double max_to) {
        return (x - min_x) / (max_x - min_x) * (max_to - min_to) + min_to;
    }

    static void chebyshevCoef(Function<Double, Double> func, double min,
            double max, double[] coef) {

        int N = coef.length;

        for (int i = 0; i < N; i++) {

            double m = map(cos(PI * (i + 0.5f) / N), -1, 1, min, max);
            double f = func.apply(m) * 2 / N;

            for (int j = 0; j < N; j++) {
                coef[j] += f * cos(PI * j * (i + 0.5f) / N);
            }
        }
    }

    public static void main(String[] args) {
        final int N = 10;
        double[] c = new double[N];
        double min = 0, max = 1;
        chebyshevCoef(x -> cos(x), min, max, c);

        System.out.println("Coefficients:");
        for (double d : c)
            System.out.println(d);
    }
}
