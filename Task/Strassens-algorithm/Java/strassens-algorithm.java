import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class Matrix {
    public List<List<Double>> data;
    public int rows;
    public int cols;

    public Matrix(List<List<Double>> data) {
        this.data = data;
        rows = data.size();
        cols = (rows > 0) ? data.get(0).size() : 0;
    }

    public int getRows() {
        return rows;
    }

    public int getCols() {
        return cols;
    }

    public void validateDimensions(Matrix other) {
        if (getRows() != other.getRows() || getCols() != other.getCols()) {
            throw new RuntimeException("Matrices must have the same dimensions.");
        }
    }

    public void validateMultiplication(Matrix other) {
        if (getCols() != other.getRows()) {
            throw new RuntimeException("Cannot multiply these matrices.");
        }
    }

    public void validateSquarePowerOfTwo() {
        if (getRows() != getCols()) {
            throw new RuntimeException("Matrix must be square.");
        }
        if (getRows() == 0 || (getRows() & (getRows() - 1)) != 0) {
            throw new RuntimeException("Size of matrix must be a power of two.");
        }
    }

    public Matrix add(Matrix other) {
        validateDimensions(other);

        List<List<Double>> resultData = new ArrayList<>();
        for (int i = 0; i < rows; ++i) {
            List<Double> row = new ArrayList<>();
            for (int j = 0; j < cols; ++j) {
                row.add(data.get(i).get(j) + other.data.get(i).get(j));
            }
            resultData.add(row);
        }

        return new Matrix(resultData);
    }

    public Matrix subtract(Matrix other) {
        validateDimensions(other);

        List<List<Double>> resultData = new ArrayList<>();
        for (int i = 0; i < rows; ++i) {
            List<Double> row = new ArrayList<>();
            for (int j = 0; j < cols; ++j) {
                row.add(data.get(i).get(j) - other.data.get(i).get(j));
            }
            resultData.add(row);
        }

        return new Matrix(resultData);
    }

    public Matrix multiply(Matrix other) {
        validateMultiplication(other);

        List<List<Double>> resultData = new ArrayList<>();
        for (int i = 0; i < rows; ++i) {
            List<Double> row = new ArrayList<>();
            for (int j = 0; j < other.cols; ++j) {
                double sum = 0.0;
                for (int k = 0; k < other.rows; ++k) {
                    sum += data.get(i).get(k) * other.data.get(k).get(j);
                }
                row.add(sum);
            }
            resultData.add(row);
        }

        return new Matrix(resultData);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (List<Double> row : data) {
            sb.append("[");
            for (int i = 0; i < row.size(); ++i) {
                sb.append(row.get(i));
                if (i < row.size() - 1) {
                    sb.append(", ");
                }
            }
            sb.append("]\n");
        }
        return sb.toString();
    }

    public String toStringWithPrecision(int p) {
        StringBuilder sb = new StringBuilder();
        double pow = Math.pow(10.0, p);

        for (List<Double> row : data) {
            sb.append("[");
            for (int i = 0; i < row.size(); ++i) {
                double r = Math.round(row.get(i) * pow) / pow;
                String formatted = String.format("%." + p + "f", r);

                if (formatted.equals("-0" + (p > 0 ? "." + "0".repeat(p) : ""))) {
                    formatted = "0" + (p > 0 ? "." + "0".repeat(p) : "");
                }

                sb.append(formatted);

                if (i < row.size() - 1) {
                    sb.append(", ");
                }
            }
            sb.append("]\n");
        }
        return sb.toString();
    }

    private static int[][] getParams(int r, int c) {
        return new int[][] {
            {0, r, 0, c, 0, 0},
            {0, r, c, 2 * c, 0, c},
            {r, 2 * r, 0, c, r, 0},
            {r, 2 * r, c, 2 * c, r, c}
        };
    }

    public Matrix[] toQuarters() {
        int r = getRows() / 2;
        int c = getCols() / 2;
        int[][] p = getParams(r, c);
        Matrix[] quarters = new Matrix[4];

        for (int k = 0; k < 4; ++k) {
            List<List<Double>> qData = new ArrayList<>();
            for (int i = 0; i < r; i++) {
                List<Double> row = new ArrayList<>();
                for (int j = 0; j < c; j++) {
                    row.add(0.0);
                }
                qData.add(row);
            }

            for (int i = p[k][0]; i < p[k][1]; ++i) {
                for (int j = p[k][2]; j < p[k][3]; ++j) {
                    qData.get(i - p[k][4]).set(j - p[k][5], data.get(i).get(j));
                }
            }
            quarters[k] = new Matrix(qData);
        }

        return quarters;
    }

    public static Matrix fromQuarters(Matrix[] q) {
        int r = q[0].getRows();
        int c = q[0].getCols();
        int[][] p = getParams(r, c);
        int rows = r * 2;
        int cols = c * 2;

        List<List<Double>> mData = new ArrayList<>();
        for (int i = 0; i < rows; i++) {
            List<Double> row = new ArrayList<>();
            for (int j = 0; j < cols; j++) {
                row.add(0.0);
            }
            mData.add(row);
        }

        for (int k = 0; k < 4; ++k) {
            for (int i = p[k][0]; i < p[k][1]; ++i) {
                for (int j = p[k][2]; j < p[k][3]; ++j) {
                    mData.get(i).set(j, q[k].data.get(i - p[k][4]).get(j - p[k][5]));
                }
            }
        }

        return new Matrix(mData);
    }

    public Matrix strassen(Matrix other) {
        validateSquarePowerOfTwo();
        other.validateSquarePowerOfTwo();
        if (getRows() != other.getRows() || getCols() != other.getCols()) {
            throw new RuntimeException("Matrices must be square and of equal size for Strassen multiplication.");
        }

        if (getRows() == 1) {
            return this.multiply(other);
        }

        Matrix[] qa = toQuarters();
        Matrix[] qb = other.toQuarters();

        Matrix p1 = qa[1].subtract(qa[3]).strassen(qb[2].add(qb[3]));
        Matrix p2 = qa[0].add(qa[3]).strassen(qb[0].add(qb[3]));
        Matrix p3 = qa[0].subtract(qa[2]).strassen(qb[0].add(qb[1]));
        Matrix p4 = qa[0].add(qa[1]).strassen(qb[3]);
        Matrix p5 = qa[0].strassen(qb[1].subtract(qb[3]));
        Matrix p6 = qa[3].strassen(qb[2].subtract(qb[0]));
        Matrix p7 = qa[2].add(qa[3]).strassen(qb[0]);

        Matrix[] q = new Matrix[4];

        q[0] = p1.add(p2).subtract(p4).add(p6);
        q[1] = p4.add(p5);
        q[2] = p6.add(p7);
        q[3] = p2.subtract(p3).add(p5).subtract(p7);

        return fromQuarters(q);
    }
}

public class Main{
    public static void main(String[] args) {
        List<List<Double>> aData = new ArrayList<>();
        aData.add(Arrays.asList(1.0, 2.0));
        aData.add(Arrays.asList(3.0, 4.0));
        Matrix a = new Matrix(aData);

        List<List<Double>> bData = new ArrayList<>();
        bData.add(Arrays.asList(5.0, 6.0));
        bData.add(Arrays.asList(7.0, 8.0));
        Matrix b = new Matrix(bData);

        List<List<Double>> cData = new ArrayList<>();
        cData.add(Arrays.asList(1.0, 1.0, 1.0, 1.0));
        cData.add(Arrays.asList(2.0, 4.0, 8.0, 16.0));
        cData.add(Arrays.asList(3.0, 9.0, 27.0, 81.0));
        cData.add(Arrays.asList(4.0, 16.0, 64.0, 256.0));
        Matrix c = new Matrix(cData);

        List<List<Double>> dData = new ArrayList<>();
        dData.add(Arrays.asList(4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0));
        dData.add(Arrays.asList(-13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0));
        dData.add(Arrays.asList(3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0));
        dData.add(Arrays.asList(-1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0));
        Matrix d = new Matrix(dData);

        List<List<Double>> eData = new ArrayList<>();
        eData.add(Arrays.asList(1.0, 2.0, 3.0, 4.0));
        eData.add(Arrays.asList(5.0, 6.0, 7.0, 8.0));
        eData.add(Arrays.asList(9.0, 10.0, 11.0, 12.0));
        eData.add(Arrays.asList(13.0, 14.0, 15.0, 16.0));
        Matrix e = new Matrix(eData);

        List<List<Double>> fData = new ArrayList<>();
        fData.add(Arrays.asList(1.0, 0.0, 0.0, 0.0));
        fData.add(Arrays.asList(0.0, 1.0, 0.0, 0.0));
        fData.add(Arrays.asList(0.0, 0.0, 1.0, 0.0));
        fData.add(Arrays.asList(0.0, 0.0, 0.0, 1.0));
        Matrix f = new Matrix(fData);

        System.out.println("Using 'normal' matrix multiplication:");
        System.out.println("  a * b = " + a.multiply(b));
        System.out.println("  c * d = " + c.multiply(d).toStringWithPrecision(6));
        System.out.println("  e * f = " + e.multiply(f));

        System.out.println("\nUsing 'Strassen' matrix multiplication:");
        System.out.println("  a * b = " + a.strassen(b));
        System.out.println("  c * d = " + c.strassen(d).toStringWithPrecision(6));
        System.out.println("  e * f = " + e.strassen(f));
    }
}
