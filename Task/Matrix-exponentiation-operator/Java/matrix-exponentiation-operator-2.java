import java.util.Arrays;

public class MatrixDemo {

    public static final class Matrix {
        private final int rows;
        private final int cols;
        private final double[][] a;

        public Matrix(double[][] data) {
            if (data == null || data.length == 0 || data[0].length == 0)
                throw new IllegalArgumentException("Matrix cannot have zero dimension");
            this.rows = data.length;
            this.cols = data[0].length;
            this.a = new double[rows][cols];
            for (int i = 0; i < rows; i++) {
                if (data[i].length != cols)
                    throw new IllegalArgumentException("Jagged arrays are not allowed");
                System.arraycopy(data[i], 0, this.a[i], 0, cols);
            }
        }

        public int rows() { return rows; }
        public int cols() { return cols; }

        public static Matrix identity(int n) {
            if (n < 1) throw new IllegalArgumentException("Size of identity matrix can't be less than 1");
            double[][] id = new double[n][n];
            for (int i = 0; i < n; i++) id[i][i] = 1.0;
            return new Matrix(id);
        }

        public Matrix multiply(Matrix other) {
            if (this.cols != other.rows)
                throw new IllegalArgumentException("Matrices cannot be multiplied: " +
                        this.rows + "x" + this.cols + " * " + other.rows + "x" + other.cols);

            double[][] r = new double[this.rows][other.cols];
            for (int i = 0; i < this.rows; i++) {
                for (int k = 0; k < this.cols; k++) {
                    double v = this.a[i][k];
                    if (v == 0) continue;
                    for (int j = 0; j < other.cols; j++) {
                        r[i][j] += v * other.a[k][j];
                    }
                }
            }
            return new Matrix(r);
        }

        public Matrix pow(int n) {
            if (rows != cols) throw new IllegalStateException("Not a square matrix");
            if (n < 0) throw new IllegalArgumentException("Negative exponents not supported");
            if (n == 0) return identity(rows);
            if (n == 1) return this;

            Matrix result = identity(rows);
            Matrix base = this;
            int e = n;
            while (e > 0) {
                if ((e & 1) == 1) result = result.multiply(base);
                e >>= 1;
                if (e > 0) base = base.multiply(base);
            }
            return result;
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append('[');
            for (int i = 0; i < rows; i++) {
                sb.append(Arrays.toString(a[i]));
                if (i < rows - 1) sb.append('\n');
            }
            sb.append(']');
            return sb.toString();
        }
    }

    public static void main(String[] args) {
        Matrix m = new Matrix(new double[][] {
                {3, 2},
                {2, 1}
        });

        for (int i = 0; i <= 10; i++) {
            System.out.println("** Power of " + i + " **");
            System.out.println(m.pow(i));
            System.out.println();
        }
    }
}
