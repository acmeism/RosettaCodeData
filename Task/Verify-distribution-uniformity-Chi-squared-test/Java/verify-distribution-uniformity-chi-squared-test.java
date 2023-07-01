import static java.lang.Math.pow;
import java.util.Arrays;
import static java.util.Arrays.stream;
import org.apache.commons.math3.special.Gamma;

public class Test {

    static double x2Dist(double[] data) {
        double avg = stream(data).sum() / data.length;
        double sqs = stream(data).reduce(0, (a, b) -> a + pow((b - avg), 2));
        return sqs / avg;
    }

    static double x2Prob(double dof, double distance) {
        return Gamma.regularizedGammaQ(dof / 2, distance / 2);
    }

    static boolean x2IsUniform(double[] data, double significance) {
        return x2Prob(data.length - 1.0, x2Dist(data)) > significance;
    }

    public static void main(String[] a) {
        double[][] dataSets = {{199809, 200665, 199607, 200270, 199649},
        {522573, 244456, 139979, 71531, 21461}};

        System.out.printf(" %4s %12s  %12s %8s   %s%n",
                "dof", "distance", "probability", "Uniform?", "dataset");

        for (double[] ds : dataSets) {
            int dof = ds.length - 1;
            double dist = x2Dist(ds);
            double prob = x2Prob(dof, dist);
            System.out.printf("%4d %12.3f  %12.8f    %5s    %6s%n",
                    dof, dist, prob, x2IsUniform(ds, 0.05) ? "YES" : "NO",
                    Arrays.toString(ds));
        }
    }
}
