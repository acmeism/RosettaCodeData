import java.util.List;
import java.util.function.Function;

public final class WelchsTTest {

	public static void main(String[] args) {
		List<Double> list1 =
			List.of( 27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6, 23.1, 19.6, 19.0, 21.7, 21.4 );
		List<Double> list2 =
			List.of( 27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2, 21.9, 22.1, 22.9, 20.5, 24.4 );
		List<Double> list3 = List.of( 17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8 );
		List<Double> list4 = List.of( 21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8, 20.7, 21.7, 21.5, 22.5, 23.6, 21.5, 22.5, 23.5, 21.5, 21.8 );
		List<Double> list5 = List.of( 19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0 );
		List<Double> list6 = List.of( 28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7, 23.2, 17.5, 20.6, 18.0, 23.9, 21.6, 24.3, 20.4, 24.0, 13.2 );
		List<Double> list7 = List.of( 30.02, 29.99, 30.11, 29.97, 30.01, 29.99 );
		List<Double> list8 = List.of( 29.89, 29.93, 29.72, 29.98, 30.02, 29.98 );

		List<Double> listX = List.of( 3.0, 4.0, 1.0, 2.1 );
		List<Double> listY = List.of( 490.2, 340.0, 433.9 );
		
		System.out.println(String.format("%.6f", p2Tail(list1, list2)));
		System.out.println(String.format("%.6f", p2Tail(list3, list4)));
		System.out.println(String.format("%.6f", p2Tail(list5, list6)));
		System.out.println(String.format("%.6f", p2Tail(list7, list8)));
		System.out.println(String.format("%.6f", p2Tail(listX, listY)));
	}
	
	private static double p2Tail(List<Double> one, List<Double> two) {
	    final double dof = degreesOfFreedom(one, two);
	    final double welch = welch(one, two);
	    final double gamm = Math.exp(lgamma(dof / 2.0) + lgamma(0.5) - lgamma(dof / 2.0 + 0.5));
	    final double b = dof / ( welch * welch + dof );
	    final Function<Double, Double> func = r -> Math.pow(r, dof / 2.0 - 1.0) / Math.sqrt(1.0 - r);
	    return simpson(0.0, b, 10_000, func) / gamm;
	}
	
	private static double simpson(double a, double b, int n, Function<Double, Double> func) {
	    final double h = ( b - a ) / n;
	    double sum = 0.0;
	    for ( int i = 0; i < n; i++ ) {
	        final double x = a + i * h;
	        sum += ( func.apply(x) + 4.0 * func.apply(x + h / 2.0) + func.apply(x + h) ) / 6.0;
	    }
	    return sum * h;
	}
	
	private static double lgamma(double x) {
		return Math.log(gamma(x));
	}
	
	private static double gamma(double x) {
		final double[] constants = new double[] {
			0.99999999999980993,
			676.5203681218851,
			-1259.1392167224028,
			771.32342877765313,
			-176.61502916214059,
			12.507343278686905,
			-0.13857109526572012,
			9.9843695780195716e-6,
			1.5056327351493116e-7
		};		
		
        if ( x < 0.5 ) {
        	return Math.PI / ( Math.sin(x * Math.PI) * gamma(1.0 - x) );
        }
        x -= 1;
        final double t = x + 7.5;
        double a = constants[0];
        for ( int i = 1; i < constants.length; i++ ) {
        	a += constants[i] / ( x + i );
        }
        return a * Math.sqrt(2.0 * Math.PI) * Math.pow(t, x + 0.5) * Math.exp(-t);	        	
	}
	
	private static double degreesOfFreedom(List<Double> one, List<Double> two) {
	    final double sv1 = sampleVariance(one);
	    final double sv2 = sampleVariance(two);
	    final int n1 = one.size();
	    final int n2 = two.size();
	    final double numer = ( sv1 / n1 + sv2 / n2 ) * ( sv1 / n1 + sv2 / n2 );
	    final double denom = ( sv1 * sv1 ) / ( n1 * n1 * ( n1 - 1 ) ) + ( sv2 * sv2 ) / ( n2 * n2 * ( n2 - 1 ) );
	    return numer / denom;
	}
	
	private static double welch(List<Double> one, List<Double> two) {
	    final double temp = sampleVariance(one) / one.size() + sampleVariance(two) / two.size();
	    return ( average(one) - average(two) ) / Math.sqrt(temp);
	}
	
	private static double sampleVariance(List<Double> list) {
		if ( list.size() < 2 ) {
	    	throw new AssertionError("List must have at least 2 elements");
	    }	
		
		final double average = average(list);
		final double sum = list.stream().map( i -> ( i - average ) * ( i - average ) )
				                        .mapToDouble(Double::valueOf).sum();		
		return sum / ( list.size() - 1 );
	}
	
	private static double average(List<Double> list) {
		return list.stream().mapToDouble(Double::valueOf).average().getAsDouble();
	}

}
