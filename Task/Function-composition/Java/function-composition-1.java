public class Compose {

    // Java doesn't have function type so we define an interface
    // of function objects instead
    public interface Fun<A,B> {
        B call(A x);
    }

    public static <A,B,C> Fun<A,C> compose(final Fun<B,C> f, final Fun<A,B> g) {
        return new Fun<A,C>() {
            public C call(A x) {
                return f.call(g.call(x));
            }
        };
    }

    public static void main(String[] args) {
        Fun<Double,Double> sin = new Fun<Double,Double>() {
            public Double call(Double x) {
                return Math.sin(x);
            }
        };
        Fun<Double,Double> asin = new Fun<Double,Double>() {
            public Double call(Double x) {
                return Math.asin(x);
            }
        };

        Fun<Double,Double> sin_asin = compose(sin, asin);

        System.out.println(sin_asin.call(0.5)); // prints "0.5"
    }
}
