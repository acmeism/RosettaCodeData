import java.util.List;

public final class StatisticsChiSquaredDistribution {

	public static void main(String[] aArgs) {	
		System.out.println("    Values of the Chi-squared probability distribution function");
		System.out.println(" x/k     1         2         3         4         5");
		for ( int x = 0; x <= 10; x++ ) {
			System.out.print(String.format("%2d", x));
			for ( int k = 1; k <= 5; k++ ) {
				System.out.print(String.format("%10.6f", pdf(x, k)));
			}
			System.out.println();
		}

		System.out.println();
		System.out.println("    Values for the Chi-squared distribution with 3 degrees of freedom");
		System.out.println("Chi-squared   cumulative pdf   p-value");
		for ( int x : List.of( 1, 2, 4, 8, 16, 32 ) ) {
			final double cdf = cdf(x, 3);
			System.out.println(String.format("%6d%19.6f%14.6f", x, cdf, ( 1.0 - cdf )));
		}
		
		final int[][] observed = { { 77, 23 }, { 88, 12 }, { 79, 21 }, { 81, 19 } };
		final double[][] expected = { { 81.25, 18.75 }, { 81.25, 18.75 }, { 81.25, 18.75 }, { 81.25, 18.75 } };
		double testStatistic = 0.0;
		for ( int i = 0; i < observed.length; i++ ) {
		    for ( int j = 0; j < observed[0].length; j++ ) {
		        testStatistic += Math.pow(observed[i][j] - expected[i][j], 2.0) / expected[i][j];
		    }
		}
		final int degreesFreedom = ( observed.length - 1 ) / ( observed[0].length - 1 );
		
		System.out.println();
		System.out.println("For the airport data:");
		System.out.println("    test statistic     : " + String.format("%.6f", testStatistic));
		System.out.println("    degrees of freedom : " + degreesFreedom);
		System.out.println("    Chi-squared        : " + String.format("%.6f", pdf(testStatistic, degreesFreedom)));
		System.out.println("    p-value            : " + String.format("%.6f", cdf(testStatistic, degreesFreedom)));		
	}
	
	// The gamma function.
	private static double gamma(double aX) {
		 if ( aX < 0.5 ) {
		     return Math.PI / ( Math.sin(Math.PI * aX) * gamma(1.0 - aX) );
		 }
		
		final double[] probabilities = new double[] {
			0.99999999999980993, 676.5203681218851, -1259.1392167224028, 771.32342877765313, -176.61502916214059,
			12.507343278686905, -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7 };
	
	    aX -= 1.0;
	    double t = probabilities[0];
	    for ( int i = 1; i < 9; i++ ) {
	        t += probabilities[i] / ( aX + i );
	    }	
	    final double w = aX + 7.5;
	    return Math.sqrt(2.0 * Math.PI) * Math.pow(w, aX + 0.5) * Math.exp(-w) * t;	
	}
	
	// The probability density function of the Chi-squared distribution.
	private static double pdf(double aX, double aK) {
		return ( aX > 0.0 ) ?
			Math.pow(aX, aK / 2 - 1) * Math.exp(-aX / 2) / ( Math.pow(2, aK / 2) * gamma(aK / 2) ) : 0.0;
	}
	
	// The cumulative probability function of the Chi-squared distribution.
	private static double cdf(double aX, double aK) {
		if ( aX > 1_000 && aK < 100 ) {
			return 1.0;
		}
		return ( aX > 0.0 && aK > 0.0 ) ? gammaCDF(aX / 2, aK / 2) : 0.0;
	}
	
	// The normalised lower incomplete gamma function.
	private static double gammaCDF(double aX, double aK) {
		double result = 0.0;
		for ( int m = 0; m <= 99; m++ ) {
			result += Math.pow(aX, m) / gamma(aK + m + 1);
		}
		result *= Math.pow(aX, aK) * Math.exp(-aX);
		return result;
	}	

}
