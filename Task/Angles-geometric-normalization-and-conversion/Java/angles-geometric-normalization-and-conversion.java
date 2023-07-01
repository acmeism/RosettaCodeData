import java.text.DecimalFormat;

//  Title:  Angles (geometric), normalization and conversion

public class AnglesNormalizationAndConversion {

    public static void main(String[] args) {
        DecimalFormat formatAngle = new DecimalFormat("######0.000000");
        DecimalFormat formatConv = new DecimalFormat("###0.0000");
        System.out.printf("                               degrees    gradiens        mils     radians%n");
        for ( double angle : new double[] {-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000} ) {
            for ( String units : new String[] {"degrees", "gradiens", "mils", "radians"}) {
                double d = 0, g = 0, m = 0, r = 0;
                switch (units) {
                case "degrees":
                    d = d2d(angle);
                    g = d2g(d);
                    m = d2m(d);
                    r = d2r(d);
                    break;
                case "gradiens":
                    g = g2g(angle);
                    d = g2d(g);
                    m = g2m(g);
                    r = g2r(g);
                    break;
                case "mils":
                    m = m2m(angle);
                    d = m2d(m);
                    g = m2g(m);
                    r = m2r(m);
                    break;
                case "radians":
                    r = r2r(angle);
                    d = r2d(r);
                    g = r2g(r);
                    m = r2m(r);
                    break;
                }
                System.out.printf("%15s  %8s = %10s  %10s  %10s  %10s%n", formatAngle.format(angle), units, formatConv.format(d), formatConv.format(g), formatConv.format(m), formatConv.format(r));
            }
        }
    }

    private static final double DEGREE = 360D;
    private static final double GRADIAN = 400D;
    private static final double MIL = 6400D;
    private static final double RADIAN = (2 * Math.PI);

    private static double d2d(double a) {
        return a % DEGREE;
    }
    private static double d2g(double a) {
        return a * (GRADIAN / DEGREE);
    }
    private static double d2m(double a) {
        return a * (MIL / DEGREE);
    }
    private static double d2r(double a) {
        return a * (RADIAN / 360);
    }

    private static double g2d(double a) {
        return a * (DEGREE / GRADIAN);
    }
    private static double g2g(double a) {
        return a % GRADIAN;
    }
    private static double g2m(double a) {
        return a * (MIL / GRADIAN);
    }
    private static double g2r(double a) {
        return a * (RADIAN / GRADIAN);
    }

    private static double m2d(double a) {
        return a * (DEGREE / MIL);
    }
    private static double m2g(double a) {
        return a * (GRADIAN / MIL);
    }
    private static double m2m(double a) {
        return a % MIL;
    }
    private static double m2r(double a) {
        return a * (RADIAN / MIL);
    }

    private static double r2d(double a) {
        return a * (DEGREE / RADIAN);
    }
    private static double r2g(double a) {
        return a * (GRADIAN / RADIAN);
    }
    private static double r2m(double a) {
        return a * (MIL / RADIAN);
    }
    private static double r2r(double a) {
        return a % RADIAN;
    }

}
