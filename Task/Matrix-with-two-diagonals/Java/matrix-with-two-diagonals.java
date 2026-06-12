package example.diagdiag;

public class Program {

    public static void main(String[] args) {
        DiagonalDiagonalMatrix A = new DiagonalDiagonalMatrix(7);
        System.out.println(A);
    }

}

class DiagonalDiagonalMatrix {

    final int n;
    private double[][] a = null;

    public Matrix(int n) {
        this.n = n;
    }

    public double get(int i, int j) {
        if (a == null) {
            return (i == j || i == n - j + 1) ? 1.0 : 0.0;
        } else {
            return a[i - 1][j - 1];
        }
    }

// Not necessary for the task: a lazy creation of the dense matrix.
//
//    public void put(int i, int j, double value) {
//        if (a == null) {
//            a = new double[n][n];
//            for (int p = 1; p <= n; i++) {
//                for (int q = 1; q <= n; j++) {
//                    a[p - 1][q - 1] = get(p, q);
//                }
//            }
//        }
//        a[i - 1][j - 1] = value;
//    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                sb.append('\t');
                sb.append(get(i, j));
            }
            sb.append('\n');
        }
        return sb.toString();
    }

}
