import java.util.Optional;

public class Steffensen {
    static double aitken(double p0) {
        double p1 = f(p0);
        double p2 = f(p1);
        double p1m0 = p1 - p0;
        return p0 - p1m0 * p1m0 / (p2 - 2.0 * p1 + p0);
    }

    static Optional<Double> steffensenAitken(double pinit, double tol, int maxiter) {
        double p0 = pinit;
        double p = aitken(p0);
        int iter = 1;
        while (Math.abs(p - p0) > tol && iter < maxiter) {
            p0 = p;
            p = aitken(p0);
            iter++;
        }
        if (Math.abs(p - p0) > tol) return Optional.empty();
        return Optional.of(p);
    }

    static double deCasteljau(double c0, double c1, double c2, double t) {
        double s = 1.0 - t;
        double c01 = s * c0 + t * c1;
        double c12 = s * c1 + t * c2;
        return s * c01 + t * c12;
    }

    static double xConvexLeftParabola(double t) {
        return deCasteljau(2.0, -8.0, 2.0, t);
    }

    static double yConvexRightParabola(double t) {
        return deCasteljau(1.0, 2.0, 3.0, t);
    }

    static double implicitEquation(double x, double y) {
        return 5.0 * x * x + y - 5.0;
    }

    static double f(double t) {
        double x = xConvexLeftParabola(t);
        double y = yConvexRightParabola(t);
        return implicitEquation(x, y) + t;
    }

    public static void main(String[] args) {
        double t0 = 0.0;
        for (int i = 0; i < 11; ++i) {
            System.out.printf("t0 = %3.1f : ", t0);
            Optional<Double> t = steffensenAitken(t0, 0.00000001, 1000);
            if (!t.isPresent()) {
                System.out.println("no answer");
            } else {
                double x = xConvexLeftParabola(t.get());
                double y = yConvexRightParabola(t.get());
                if (Math.abs(implicitEquation(x, y)) <= 0.000001) {
                    System.out.printf("intersection at (%f, %f)\n", x, y);
                } else {
                    System.out.println("spurious solution");
                }
            }
            t0 += 0.1;
        }
    }
}
