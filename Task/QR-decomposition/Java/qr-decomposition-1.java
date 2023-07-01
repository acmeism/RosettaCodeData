import Jama.Matrix;
import Jama.QRDecomposition;

public class Decompose {
    public static void main(String[] args) {
        var matrix = new Matrix(new double[][] {
            {12, -51,   4},
            { 6, 167, -68},
            {-4,  24, -41},
        });

        var qr = new QRDecomposition(matrix);
        qr.getQ().print(10, 4);
        qr.getR().print(10, 4);
    }
}
