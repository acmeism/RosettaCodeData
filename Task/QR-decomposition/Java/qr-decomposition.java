import Jama.Matrix;
import Jama.QRDecomposition;

import java.io.StringWriter;
import java.io.PrintWriter;

public class Decompose {
    public static void main(String[] args) {
        Matrix matrix = new Matrix(new double[][] {
            { 12, -51,   4 },
            {  6, 167, -68 },
            { -4,  24, -41 },
        });

        QRDecomposition d = new QRDecomposition(matrix);
        System.out.print(toString(d.getQ()));
        System.out.print(toString(d.getR()));
    }

    public static String toString(Matrix m) {
        StringWriter sw = new StringWriter();
        m.print(new PrintWriter(sw, true), 8, 6);
        return sw.toString();
    }
}
