import java.util.Arrays;

public class Fivenum {

    static double median(double[] x, int start, int endInclusive) {
        int size = endInclusive - start + 1;
        if (size <= 0) throw new IllegalArgumentException("Array slice cannot be empty");
        int m = start + size / 2;
        return (size % 2 == 1) ? x[m] : (x[m - 1] + x[m]) / 2.0;
    }

    static double[] fivenum(double[] x) {
        for (Double d : x) {
            if (d.isNaN())
                throw new IllegalArgumentException("Unable to deal with arrays containing NaN");
        }
        double[] result = new double[5];
        Arrays.sort(x);
        result[0] = x[0];
        result[2] = median(x, 0, x.length - 1);
        result[4] = x[x.length - 1];
        int m = x.length / 2;
        int lowerEnd = (x.length % 2 == 1) ? m : m - 1;
        result[1] = median(x, 0, lowerEnd);
        result[3] = median(x, m, x.length - 1);
        return result;
    }

    public static void main(String[] args) {
        double xl[][] = {
            {15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0},
            {36.0, 40.0, 7.0, 39.0, 41.0, 15.0},
            {
                 0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
                -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
                -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
                 0.75775634,  0.32566578
            }
        };
        for (double[] x : xl) System.out.printf("%s\n\n", Arrays.toString(fivenum(x)));
    }
}
