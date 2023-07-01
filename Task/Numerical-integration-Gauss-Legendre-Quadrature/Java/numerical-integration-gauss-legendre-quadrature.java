import static java.lang.Math.*;
import java.util.function.Function;

public class Test {
    final static int N = 5;

    static double[] lroots = new double[N];
    static double[] weight = new double[N];
    static double[][] lcoef = new double[N + 1][N + 1];

    static void legeCoef() {
        lcoef[0][0] = lcoef[1][1] = 1;

        for (int n = 2; n <= N; n++) {

            lcoef[n][0] = -(n - 1) * lcoef[n - 2][0] / n;

            for (int i = 1; i <= n; i++) {
                lcoef[n][i] = ((2 * n - 1) * lcoef[n - 1][i - 1]
                        - (n - 1) * lcoef[n - 2][i]) / n;
            }
        }
    }

    static double legeEval(int n, double x) {
        double s = lcoef[n][n];
        for (int i = n; i > 0; i--)
            s = s * x + lcoef[n][i - 1];
        return s;
    }

    static double legeDiff(int n, double x) {
        return n * (x * legeEval(n, x) - legeEval(n - 1, x)) / (x * x - 1);
    }

    static void legeRoots() {
        double x, x1;
        for (int i = 1; i <= N; i++) {
            x = cos(PI * (i - 0.25) / (N + 0.5));
            do {
                x1 = x;
                x -= legeEval(N, x) / legeDiff(N, x);
            } while (x != x1);

            lroots[i - 1] = x;

            x1 = legeDiff(N, x);
            weight[i - 1] = 2 / ((1 - x * x) * x1 * x1);
        }
    }

    static double legeInte(Function<Double, Double> f, double a, double b) {
        double c1 = (b - a) / 2, c2 = (b + a) / 2, sum = 0;
        for (int i = 0; i < N; i++)
            sum += weight[i] * f.apply(c1 * lroots[i] + c2);
        return c1 * sum;
    }

    public static void main(String[] args) {
        legeCoef();
        legeRoots();

        System.out.print("Roots: ");
        for (int i = 0; i < N; i++)
            System.out.printf(" %f", lroots[i]);

        System.out.print("\nWeight:");
        for (int i = 0; i < N; i++)
            System.out.printf(" %f", weight[i]);

        System.out.printf("%nintegrating Exp(x) over [-3, 3]:%n\t%10.8f,%n"
                + "compared to actual%n\t%10.8f%n",
                legeInte(x -> exp(x), -3, 3), exp(3) - exp(-3));
    }
}
