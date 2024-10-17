import java.util.function.BiFunction;
import java.util.function.DoubleUnaryOperator;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.UnaryOperator;

public final class FunctionDefinition {

	public static void main(String[] args) {
		System.out.println(size.apply("Rosetta"));
		System.out.println(greeting.apply("Joe"));
		System.out.println(half.applyAsDouble(7));
		System.out.println(lessThanTen.test(15));
		System.out.println(add.apply(2, 3));
	}	
	
	private static Function<String, Integer> size = s -> s.length();
	
	private static UnaryOperator<String> greeting = s -> "Hello " + s;
	
	private static DoubleUnaryOperator half = a -> a / 2;
	
	private static Predicate<Integer> lessThanTen = a -> a < 10;
	
	private static BiFunction<Integer, Integer, Integer> add = (a, b) -> a + b;	

}
