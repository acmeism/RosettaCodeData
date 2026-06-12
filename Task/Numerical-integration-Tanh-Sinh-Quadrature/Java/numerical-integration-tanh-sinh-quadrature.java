import java.util.function.Function;

public final class NumericalIntegrationTanhSinhQuadrature {

	public static void main(String[] args) {
		System.out.println(tanhSinh(x -> Math.sin(x), 0.0, 1.0, 5, 1e-8));
		System.out.println(tanhSinh(x -> Math.exp(x), -3.0, 3.0, 5, 1e-8));
	}
	
	private static double tanhSinh(Function<Double, Double> function,
			double lowerLimit, double upperLimit, int stepCount, double accuracy) {
		final double h = 0.1;
		final double h0 = ( upperLimit - lowerLimit ) / 2.0;
		final double h1 = ( lowerLimit + upperLimit ) / 2.0;
		double result = 0.0;
		for ( int k = 1; k <= stepCount; k++ ) {
			final int n = ( 1 << k ) - 1;
			double r = result;			
			double ss = 0.0;
			for ( int i = -n; i <= n; i++ ) {
				final double t = i * h;
				final double sinh = Math.sinh(t);
				final double cosh = Math.cosh(t);
				final double tanh = Math.tanh(sinh * Math.PI / 2.0);
				final double dx = ( cosh * Math.PI / 2.0 ) / Math.pow(Math.cosh(sinh * Math.PI / 2.0), 2.0);
				final double xi = h1 + h0 * tanh;
				final double wt = h * dx;
				ss += function.apply(xi) * wt;
			}
			result = h0 * ss;
			if ( Math.abs(result - r) < accuracy ) {
				break;
			}
		}
		return result;
	}

}
