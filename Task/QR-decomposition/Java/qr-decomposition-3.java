import java.util.Locale;

import org.apache.commons.math3.linear.Array2DRowRealMatrix;
import org.apache.commons.math3.linear.QRDecomposition;
import org.apache.commons.math3.linear.RealMatrix;

public class Decompose {
    public static void main(String[] args) {
        var a = new Array2DRowRealMatrix(new double[][] {
            {12, -51,   4},
            { 6, 167, -68},
            {-4,  24, -41}
        });

        var qr = new QRDecomposition(a);
        print(qr.getQ());
        System.out.println();
        print(qr.getR());
    }

    public static void print(RealMatrix a) {
        for (double[] u: a.getData()) {
            System.out.print("[ ");
            for (double x: u) {
                System.out.printf(Locale.ROOT, "%10.4f ", x);
            }
            System.out.println("]");
        }
    }
}
