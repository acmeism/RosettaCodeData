import java.util.Locale;

public class GaussianElimination {
    public static double solve(double[][] a, double[][] b) {
        if (a == null || b == null || a.length == 0 || b.length == 0) {
            throw new IllegalArgumentException("Invalid dimensions");
        }

        int n = b.length, p = b[0].length;
        if (a.length != n || a[0].length != n) {
            throw new IllegalArgumentException("Invalid dimensions");
        }

        double det = 1.0;

        for (int i = 0; i < n - 1; i++) {
            int k = i;
            for (int j = i + 1; j < n; j++) {
                if (Math.abs(a[j][i]) > Math.abs(a[k][i])) {
                    k = j;
                }
            }

            if (k != i) {
                det = -det;

                for (int j = i; j < n; j++) {
                    double s = a[i][j];
                    a[i][j] = a[k][j];
                    a[k][j] = s;
                }

                for (int j = 0; j < p; j++) {
                    double s = b[i][j];
                    b[i][j] = b[k][j];
                    b[k][j] = s;
                }
            }

            for (int j = i + 1; j < n; j++) {
                double s = a[j][i] / a[i][i];
                for (k = i + 1; k < n; k++) {
                    a[j][k] -= s * a[i][k];
                }

                for (k = 0; k < p; k++) {
                    b[j][k] -= s * b[i][k];
                }
            }
        }

        for (int i = n - 1; i >= 0; i--) {
            for (int j = i + 1; j < n; j++) {
                double s = a[i][j];
                for (int k = 0; k < p; k++) {
                    b[i][k] -= s * b[j][k];
                }
            }
            double s = a[i][i];
            det *= s;
            for (int k = 0; k < p; k++) {
                b[i][k] /= s;
            }
        }

        return det;
    }

    public static void main(String[] args) {
        double[][] a = new double[][] {{4.0, 1.0, 0.0, 0.0, 0.0},
                                       {1.0, 4.0, 1.0, 0.0, 0.0},
                                       {0.0, 1.0, 4.0, 1.0, 0.0},
                                       {0.0, 0.0, 1.0, 4.0, 1.0},
                                       {0.0, 0.0, 0.0, 1.0, 4.0}};

        double[][] b = new double[][] {{1.0 / 2.0},
                                       {2.0 / 3.0},
                                       {3.0 / 4.0},
                                       {4.0 / 5.0},
                                       {5.0 / 6.0}};

        double[] x = {39.0 / 400.0,
                      11.0 / 100.0,
                      31.0 / 240.0,
                      37.0 / 300.0,
                      71.0 / 400.0};

        System.out.println("det: " + solve(a, b));


        for (int i = 0; i < 5; i++) {
            System.out.printf(Locale.US, "%12.8f %12.4e\n", b[i][0], b[i][0] - x[i]);
        }
    }
}
