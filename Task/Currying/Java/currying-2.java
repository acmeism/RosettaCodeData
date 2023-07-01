import java.util.function.BiFunction;
import java.util.function.Function;

public class Curry {
	
	//Curry a method
	public static <T, U, R> Function<T, Function<U, R>> curry(BiFunction<T, U, R> biFunction) {
		return t -> u -> biFunction.apply(t, u);
	}
	
	public static int add(int x, int y) {
		return x + y;
	}
	
	public static void curryMethod() {
		BiFunction<Integer, Integer, Integer> bif = Curry::add;
		Function<Integer, Function<Integer, Integer>> add = curry(bif);
		Function<Integer, Integer> add5 = add.apply(5);
		System.out.println(add5.apply(2));
	}

	//Or declare the curried function in one line
	public static void curryDirectly() {
		Function<Integer, Function<Integer, Integer>> add = x -> y -> x + y;
		Function<Integer, Integer> add5 = add.apply(5);
		System.out.println(add5.apply(2));
	}
	
	//prints 7 and 7
	public static void main(String[] args) {
		curryMethod();
		curryDirectly();
	}
}
