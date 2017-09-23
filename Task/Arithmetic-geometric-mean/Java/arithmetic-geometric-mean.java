/*
 * Arithmetic-Geometric Mean of 1 & 1/sqrt(2)
 * Brendan Shaklovitz
 * 5/29/12
 */
public class ArithmeticGeometricMean {

    public static double agm(double a, double g) {
        double a1 = a;
        double g1 = g;
        while (Math.abs(a1 - g1) >= 1.0e-14) {
            double arith = (a1 + g1) / 2.0;
            double geom = Math.sqrt(a1 * g1);
            a1 = arith;
            g1 = geom;
        }
        return a1;
    }

    public static void main(String[] args) {
        System.out.println(agm(1.0, 1.0 / Math.sqrt(2.0)));
    }
}
