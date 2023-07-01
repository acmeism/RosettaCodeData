import java.util.Arrays;
import java.util.Objects;

public class MultipleRegression {
    public static void require(boolean condition, String message) {
        if (condition) {
            return;
        }
        throw new IllegalArgumentException(message);
    }

    public static class Matrix {
        private final double[][] data;
        private final int rowCount;
        private final int colCount;

        public Matrix(int rows, int cols) {
            require(rows > 0, "Need at least one row");
            this.rowCount = rows;

            require(cols > 0, "Need at least one column");
            this.colCount = cols;

            this.data = new double[rows][cols];
            for (double[] row : this.data) {
                Arrays.fill(row, 0.0);
            }
        }

        public Matrix(double[][] source) {
            require(source.length > 0, "Need at least one row");
            this.rowCount = source.length;

            require(source[0].length > 0, "Need at least one column");
            this.colCount = source[0].length;

            this.data = new double[this.rowCount][this.colCount];
            for (int i = 0; i < this.rowCount; i++) {
                set(i, source[i]);
            }
        }

        public double[] get(int row) {
            Objects.checkIndex(row, this.rowCount);
            return this.data[row];
        }

        public void set(int row, double[] data) {
            Objects.checkIndex(row, this.rowCount);
            require(data.length == this.colCount, "The column in the row must match the number of columns in the matrix");
            System.arraycopy(data, 0, this.data[row], 0, this.colCount);
        }

        public double get(int row, int col) {
            Objects.checkIndex(row, this.rowCount);
            Objects.checkIndex(col, this.colCount);
            return this.data[row][col];
        }

        public void set(int row, int col, double value) {
            Objects.checkIndex(row, this.rowCount);
            Objects.checkIndex(col, this.colCount);
            this.data[row][col] = value;
        }

        @SuppressWarnings("UnnecessaryLocalVariable")
        public Matrix times(Matrix that) {
            var rc1 = this.rowCount;
            var cc1 = this.colCount;
            var rc2 = that.rowCount;
            var cc2 = that.colCount;
            require(cc1 == rc2, "Cannot multiply if the first columns does not equal the second rows");
            var result = new Matrix(rc1, cc2);
            for (int i = 0; i < rc1; i++) {
                for (int j = 0; j < cc2; j++) {
                    for (int k = 0; k < rc2; k++) {
                        var prod = get(i, k) * that.get(k, j);
                        result.set(i, j, result.get(i, j) + prod);
                    }
                }
            }
            return result;
        }

        public Matrix transpose() {
            var rc = this.rowCount;
            var cc = this.colCount;
            var trans = new Matrix(cc, rc);
            for (int i = 0; i < cc; i++) {
                for (int j = 0; j < rc; j++) {
                    trans.set(i, j, get(j, i));
                }
            }
            return trans;
        }

        public void toReducedRowEchelonForm() {
            int lead = 0;
            var rc = this.rowCount;
            var cc = this.colCount;
            for (int r = 0; r < rc; r++) {
                if (cc <= lead) {
                    return;
                }
                var i = r;

                while (get(i, lead) == 0.0) {
                    i++;
                    if (rc == i) {
                        i = r;
                        lead++;
                        if (cc == lead) {
                            return;
                        }
                    }
                }

                var temp = get(i);
                set(i, get(r));
                set(r, temp);

                if (get(r, lead) != 0.0) {
                    var div = get(r, lead);
                    for (int j = 0; j < cc; j++) {
                        set(r, j, get(r, j) / div);
                    }
                }

                for (int k = 0; k < rc; k++) {
                    if (k != r) {
                        var mult = get(k, lead);
                        for (int j = 0; j < cc; j++) {
                            var prod = get(r, j) * mult;
                            set(k, j, get(k, j) - prod);
                        }
                    }
                }

                lead++;
            }
        }

        public Matrix inverse() {
            require(this.rowCount == this.colCount, "Not a square matrix");
            var len = this.rowCount;
            var aug = new Matrix(len, 2 * len);
            for (int i = 0; i < len; i++) {
                for (int j = 0; j < len; j++) {
                    aug.set(i, j, get(i, j));
                }
                // augment identity matrix to right
                aug.set(i, i + len, 1.0);
            }
            aug.toReducedRowEchelonForm();
            var inv = new Matrix(len, len);
            // remove identity matrix to left
            for (int i = 0; i < len; i++) {
                for (int j = len; j < 2 * len; j++) {
                    inv.set(i, j - len, aug.get(i, j));
                }
            }
            return inv;
        }
    }

    public static double[] multipleRegression(double[] y, Matrix x) {
        var tm = new Matrix(new double[][]{y});
        var cy = tm.transpose();
        var cx = x.transpose();
        return x.times(cx).inverse().times(x).times(cy).transpose().get(0);
    }

    public static void printVector(double[] v) {
        System.out.println(Arrays.toString(v));
        System.out.println();
    }

    public static double[] repeat(int size, double value) {
        var a = new double[size];
        Arrays.fill(a, value);
        return a;
    }

    public static void main(String[] args) {
        double[] y = new double[]{1.0, 2.0, 3.0, 4.0, 5.0};
        var x = new Matrix(new double[][]{{2.0, 1.0, 3.0, 4.0, 5.0}});
        var v = multipleRegression(y, x);
        printVector(v);

        y = new double[]{3.0, 4.0, 5.0};
        x = new Matrix(new double[][]{
            {1.0, 2.0, 1.0},
            {1.0, 1.0, 2.0}
        });
        v = multipleRegression(y, x);
        printVector(v);

        y = new double[]{52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29, 63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46};
        var a = new double[]{1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83};
        x = new Matrix(new double[][]{
            repeat(a.length, 1.0),
            a,
            Arrays.stream(a).map(it -> it * it).toArray()
        });

        v = multipleRegression(y, x);
        printVector(v);
    }
}
