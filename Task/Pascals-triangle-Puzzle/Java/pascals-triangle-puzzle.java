import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class PascalsTrianglePuzzle {

    public static void main(String[] args) {
        Matrix mat = new Matrix(Arrays.asList(1d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, -1d, 0d, 0d),
                                Arrays.asList(0d, 1d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, -1d, 0d),
                                Arrays.asList(0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, -1d, 1d, -1d),
                                Arrays.asList(0d, 0d, 1d, 0d, 0d, 0d, 0d, 0d, 0d, -1d, 0d),
                                Arrays.asList(0d, 0d, 0d, 1d, 0d, 0d, 0d, 0d, 0d, 0d, -1d),
                                Arrays.asList(1d, 1d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d, 0d),
                                Arrays.asList(0d, 1d, 1d, 0d, -1d, 0d, 0d, 0d, 0d, 0d, 0d),
                                Arrays.asList(0d, 0d, 1d, 1d, 0d, -1d, 0d, 0d, 0d, 0d, 0d),
                                Arrays.asList(0d, 0d, 0d, 0d, -1d, 0d, 1d, 0d, 0d, 0d, 0d),
                                Arrays.asList(0d, 0d, 0d, 0d, 1d, 1d, 0d, -1d, 0d, 0d, 0d),
                                Arrays.asList(0d, 0d, 0d, 0d, 0d, 0d, 1d, 1d, 0d, 0d, 0d));
        List<Double> b = Arrays.asList(11d, 11d, 0d, 4d, 4d, 40d, 0d, 0d, 40d, 0d, 151d);
        List<Double> solution = cramersRule(mat, b);
        System.out.println("Solution = " + cramersRule(mat, b));
        System.out.printf("X = %.2f%n", solution.get(8));
        System.out.printf("Y = %.2f%n", solution.get(9));
        System.out.printf("Z = %.2f%n", solution.get(10));
    }

    private static List<Double> cramersRule(Matrix matrix, List<Double> b) {
        double denominator = matrix.determinant();
        List<Double> result = new ArrayList<>();
        for ( int i = 0 ; i < b.size() ; i++ ) {
            result.add(matrix.replaceColumn(b, i).determinant() / denominator);
        }
        return result;
    }

    private static class Matrix {

        private List<List<Double>> matrix;

        @Override
        public String toString() {
            return matrix.toString();
        }

        @SafeVarargs
        public Matrix(List<Double> ... lists) {
            matrix = new ArrayList<>();
            for ( List<Double> list : lists) {
                matrix.add(list);
            }
        }

        public Matrix(List<List<Double>> mat) {
            matrix = mat;
        }

        public double determinant() {
            if ( matrix.size() == 1 ) {
                return get(0, 0);
            }
            if ( matrix.size() == 2 ) {
                return get(0, 0) * get(1, 1) - get(0, 1) * get(1, 0);
            }
            double sum = 0;
            double sign = 1;
            for ( int i = 0 ; i < matrix.size() ; i++ ) {
                sum += sign * get(0, i) * coFactor(0, i).determinant();
                sign *= -1;
            }
            return sum;
        }

        private Matrix coFactor(int row, int col) {
            List<List<Double>> mat = new ArrayList<>();
            for ( int i = 0 ; i < matrix.size() ; i++ ) {
                if ( i == row ) {
                    continue;
                }
                List<Double> list = new ArrayList<>();
                for ( int j = 0 ; j < matrix.size() ; j++ ) {
                    if ( j == col ) {
                        continue;
                    }
                    list.add(get(i, j));
                }
                mat.add(list);
            }
            return new Matrix(mat);
        }

        private Matrix replaceColumn(List<Double> b, int column) {
            List<List<Double>> mat = new ArrayList<>();
            for ( int row = 0 ; row < matrix.size() ; row++ ) {
                List<Double> list = new ArrayList<>();
                for ( int col = 0 ; col < matrix.size() ; col++ ) {
                    double value = get(row, col);
                    if ( col == column ) {
                        value = b.get(row);
                    }
                    list.add(value);
                }
                mat.add(list);
            }
            return new Matrix(mat);
        }

        private double get(int row, int col) {
            return matrix.get(row).get(col);
        }

    }

}
