import java.util.function.Function;

public class Compose {
    public static void main(String[] args) {
        Function<Double,Double> sin_asin = ((Function<Double,Double>)Math::sin).compose(Math::asin);

        System.out.println(sin_asin.apply(0.5)); // prints "0.5"
    }
}
