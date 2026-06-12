import java.util.function.Function;

public class NumericalIntegrationAdaptiveSimpsons {

    public static void main(String[] args) {
        Function<Double,Double> f = x -> sin(x);
        System.out.printf("integrate sin(x), x = 0 .. Pi = %2.12f.  Function calls = %d%n", quadratureAdaptiveSimpsons(f, 0, Math.PI, 1e-8), functionCount);
        functionCount = 0;
        System.out.printf("integrate sin(x), x = 0 .. 1 = %2.12f.  Function calls = %d%n", quadratureAdaptiveSimpsons(f, 0, 1, 1e-8), functionCount);
    }

    private static double quadratureAdaptiveSimpsons(Function<Double,Double> function, double a, double b, double error) {
        double fa = function.apply(a);
        double fb = function.apply(b);
        Triple t =  quadratureAdaptiveSimpsonsOne(function, a, fa, b ,fb);
        return quadratureAdaptiveSimpsonsRecursive(function, a, fa, b, fb, error, t.s, t.x, t.fx);
    }

    private static double quadratureAdaptiveSimpsonsRecursive(Function<Double,Double> function, double a, double fa, double b, double fb, double error, double whole, double m, double fm) {
        Triple left  = quadratureAdaptiveSimpsonsOne(function, a, fa, m, fm);
        Triple right = quadratureAdaptiveSimpsonsOne(function, m, fm, b, fb);
        double delta = left.s + right.s - whole;
        if ( Math.abs(delta) <= 15*error ) {
            return left.s + right.s + delta / 15;
        }
        return quadratureAdaptiveSimpsonsRecursive(function, a, fa, m, fm, error/2, left.s, left.x, left.fx) +
               quadratureAdaptiveSimpsonsRecursive(function, m, fm, b, fb, error/2, right.s, right.x, right.fx);
    }

    private static Triple quadratureAdaptiveSimpsonsOne(Function<Double,Double> function, double a, double fa, double b, double fb) {
        double m = (a + b) / 2;
        double fm = function.apply(m);
        return new Triple(m, fm, Math.abs(b-a) / 6 * (fa + 4*fm + fb));
    }

    private static class Triple {
        double x, fx, s;
        private Triple(double m, double fm, double s) {
            this.x = m;
            this.fx = fm;
            this.s = s;
        }
    }

    private static int functionCount = 0;

    private static double sin(double x) {
        functionCount++;
        return Math.sin(x);
    }

}
