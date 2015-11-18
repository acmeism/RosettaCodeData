import java.util.function.Function;

public class Compose {
    public static <A,B,C> Function<A,C> compose(Function<B,C> f, Function<A,B> g) {
        return x -> f.apply(g.apply(x));
    }

    public static void main(String[] args) {
        Function<Double,Double> sin_asin = compose(Math::sin, Math::asin);

        System.out.println(sin_asin.apply(0.5)); // prints "0.5"
    }
}
