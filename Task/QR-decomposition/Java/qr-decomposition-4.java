import org.la4j.Matrix;
import org.la4j.decomposition.QRDecompositor;

public class Decompose {
    public static void main(String[] args) {
        var a = Matrix.from2DArray(new double[][] {
            {12, -51,   4},
            { 6, 167, -68},
            {-4,  24, -41},
        });

        Matrix[] qr = new QRDecompositor(a).decompose();
        System.out.println(qr[0]);
        System.out.println(qr[1]);
    }
}
