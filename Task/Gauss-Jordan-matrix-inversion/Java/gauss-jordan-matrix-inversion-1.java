// GaussJordan.java

import java.util.Random;

public class GaussJordan {
    public static void main(String[] args) {
        int rows = 5;
        Matrix m = new Matrix(rows, rows);
        Random r = new Random();
        for (int row = 0; row < rows; ++row) {
            for (int column = 0; column < rows; ++column)
                m.set(row, column, r.nextDouble());
        }
        System.out.println("Matrix:");
        m.print();
        System.out.println("Inverse:");
        Matrix inv = m.inverse();
        inv.print();
        System.out.println("Product of matrix and inverse:");
        Matrix.product(m, inv).print();
    }
}
