import java.util.List;
import java.util.function.BiFunction;
import java.util.function.Function;

public final class FirstClassFunctionsUseNumbersAnalogously {

	public static void main(String[] args) {
		final double x = 2.0,   xi = 0.5,
				 	 y = 4.0,   yi = 0.25,
				 	 z = x + y, zi = 1.0 / ( x + y );

		List<Double> list = List.of( x, y, z );
		List<Double> inverseList = List.of( xi, yi, zi );		
		
		BiFunction<Double, Double, Function<Double, Double>> multiplier = (a, b) -> product -> a * b * product;
		
		for ( int i = 0; i < list.size(); i++ ) {
			Function<Double, Double> multiply = multiplier.apply(list.get(i), inverseList.get(i));
			final double argument = (double) ( i + 1 );
			System.out.println(multiply.apply(argument));
		}		
	}

}
