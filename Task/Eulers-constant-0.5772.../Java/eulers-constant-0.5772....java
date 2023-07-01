/**
 * Using a simple formula derived from Hurwitz zeta function,
 * as described on https://en.wikipedia.org/wiki/Euler%27s_constant,
 * gives a result accurate to 12 decimal places.
 */
public class EulerConstant {

	public static void main(String[] args) {		
		System.out.println(gamma(1_000_000));
	}

    private static double gamma(int N) {
		double gamma = 0.0;
		
		for ( int n = 1; n <= N; n++ ) {
			gamma += 1.0 / n;
		}
		
		gamma -= Math.log(N) + 1.0 / ( 2 * N );
		
		return gamma;
	}
	
}
