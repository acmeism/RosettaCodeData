import static java.util.Arrays.stream;
import java.util.Locale;
import static java.util.stream.IntStream.range;

public class Test {

    static double dotProduct(double[] a, double[] b) {
        return range(0, a.length).mapToDouble(i -> a[i] * b[i]).sum();
    }

    static double[][] matrixMul(double[][] A, double[][] B) {
        double[][] result = new double[A.length][B[0].length];
        double[] aux = new double[B.length];

        for (int j = 0; j < B[0].length; j++) {

            for (int k = 0; k < B.length; k++)
                aux[k] = B[k][j];

            for (int i = 0; i < A.length; i++)
                result[i][j] = dotProduct(A[i], aux);
        }
        return result;
    }

    static double[][] pivotize(double[][] m) {
        int n = m.length;
        double[][] id = range(0, n).mapToObj(j -> range(0, n)
                .mapToDouble(i -> i == j ? 1 : 0).toArray())
                .toArray(double[][]::new);

        for (int i = 0; i < n; i++) {
            double maxm = m[i][i];
            int row = i;
            for (int j = i; j < n; j++)
                if (m[j][i] > maxm) {
                    maxm = m[j][i];
                    row = j;
                }

            if (i != row) {
                double[] tmp = id[i];
                id[i] = id[row];
                id[row] = tmp;
            }
        }
        return id;
    }

    static double[][][] lu(double[][] A) {
        int n = A.length;
        double[][] L = new double[n][n];
        double[][] U = new double[n][n];
        double[][] P = pivotize(A);
        double[][] A2 = matrixMul(P, A);

        for (int j = 0; j < n; j++) {
            L[j][j] = 1;
            for (int i = 0; i < j + 1; i++) {
                double s1 = 0;
                for (int k = 0; k < i; k++)
                    s1 += U[k][j] * L[i][k];
                U[i][j] = A2[i][j] - s1;
            }
            for (int i = j; i < n; i++) {
                double s2 = 0;
                for (int k = 0; k < j; k++)
                    s2 += U[k][j] * L[i][k];
                L[i][j] = (A2[i][j] - s2) / U[j][j];
            }
        }
        return new double[][][]{L, U, P};
    }

    static void print(double[][] m) {
        stream(m).forEach(a -> {
            stream(a).forEach(n -> System.out.printf(Locale.US, "%5.1f ", n));
            System.out.println();
        });
        System.out.println();
    }

    public static void main(String[] args) {
        double[][] a = {{1.0, 3, 5}, {2.0, 4, 7}, {1.0, 1, 0}};

        double[][] b = {{11.0, 9, 24, 2}, {1.0, 5, 2, 6}, {3.0, 17, 18, 1},
        {2.0, 5, 7, 1}};

        for (double[][] m : lu(a))
            print(m);

        System.out.println();

        for (double[][] m : lu(b))
            print(m);
    }
}
