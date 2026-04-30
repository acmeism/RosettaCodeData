import java.math.BigInteger;
import java.util.Arrays;

public class Matrix<T extends Number> {
    private final T[][] matrix;
    private final int rows;
    private final int cols;

    public Matrix(T[][] matrix) {
        this.matrix = matrix;
        this.rows = matrix.length;
        this.cols = matrix[0].length;
    }

    public T[] row(int i) {
        return matrix[i];
    }

    @SuppressWarnings("unchecked")
    public T[] col(int i) {
        T[] column = (T[]) new Number[rows];
        for (int j = 0; j < rows; j++) {
            column[j] = matrix[j][i];
        }
        return column;
    }

    @SuppressWarnings("unchecked")
    public Matrix<T> multiply(Matrix<T> other) {
        if (this.cols != other.rows) {
            throw new IllegalArgumentException("Matrix dimensions do not match for multiplication.");
        }

        T[][] result = (T[][]) new Number[this.rows][other.cols];
        for (int i = 0; i < this.rows; i++) {
            for (int j = 0; j < other.cols; j++) {
                result[i][j] = zero();
                for (int k = 0; k < this.cols; k++) {
                    result[i][j] = add(result[i][j], multiply(this.matrix[i][k], other.matrix[k][j]));
                }
            }
        }
        return new Matrix<>(result);
    }

    @SuppressWarnings("unchecked")
    public Matrix<T> power(int x) {
        if (x < 0) {
            throw new IllegalArgumentException("Power must be non-negative.");
        }
        if (x == 0) {
            return createIdentityMatrix();
        } else if (x == 1) {
            return this;
        } else if (x == 2) {
            return this.multiply(this);
        } else {
            Matrix<T> result = this;
            for (int i = 1; i < x; i++) {
                result = result.multiply(this);
            }
            return result;
        }
    }

    @SuppressWarnings("unchecked")
    public Matrix<T> createIdentityMatrix() {
        T[][] identity = (T[][]) new Number[rows][cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                identity[i][j] = (i == j) ? one() : zero();
            }
        }
        return new Matrix<>(identity);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (T[] row : matrix) {
            sb.append(Arrays.toString(row)).append("\n");
        }
        return sb.toString();
    }

    // Helper methods for numeric operations
    private T zero() {
        return (T) BigInteger.ZERO;
    }

    private T one() {
        return (T) BigInteger.ONE;
    }

    private T add(T a, T b) {
        return (T) ((BigInteger) a).add((BigInteger) b);
    }

    private T multiply(T a, T b) {
        return (T) ((BigInteger) a).multiply((BigInteger) b);
    }

    public static void main(String[] args) {
        BigInteger[][] data = {
            {BigInteger.valueOf(3), BigInteger.valueOf(2)},
            {BigInteger.valueOf(2), BigInteger.valueOf(1)}
        };
        Matrix<BigInteger> m = new Matrix<>(data);
        System.out.println("-- m --\n" + m);

        int[] powers = {0, 1, 2, 3, 4, 10, 20, 50};
        for (int x : powers) {
            System.out.println("-- m**" + x + " --");
            System.out.println(m.power(x));
        }
    }
}
