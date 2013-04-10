import com.google.common.base.Function;

public class AccumulatorFactory {
	private static Function<Double, Double> accumulator(final Double elem) {
		return new Function<Double, Double>() {
			Double sum = elem;
			@Override public Double apply(Double val) {
				return sum += val;
			}
		};
	}

	public static void main(String[] args) {
		Function<Double, Double> x = accumulator(1d);
		x.apply(5d);
		System.out.println(accumulator(3d));		
		System.out.println(x.apply(2.3));
	}
}
