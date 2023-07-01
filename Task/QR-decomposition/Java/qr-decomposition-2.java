import cern.colt.matrix.impl.DenseDoubleMatrix2D;
import cern.colt.matrix.linalg.QRDecomposition;

public class Decompose {
    public static void main(String[] args) {
        var a = new DenseDoubleMatrix2D(new double[][] {
            {12, -51,   4},
            { 6, 167, -68},
            {-4,  24, -41}
        });
        var qr = new QRDecomposition(a);
        System.out.println(qr.getQ());
        System.out.println();
        System.out.println(qr.getR());
    }
}
