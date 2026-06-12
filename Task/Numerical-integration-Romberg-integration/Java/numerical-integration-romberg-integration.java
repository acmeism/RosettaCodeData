import java.util.function.Function;

public final class NumericalIntegrationRombergIntegration {

	public static void main(String[] args) {
		System.out.println(rombergIntegration(x -> Math.sin(x), 0.0, 1.0, 5, 1e-8));
		System.out.println(rombergIntegration(x -> Math.exp(x), -3.0, 3.0, 5, 1e-8));
	}
	
	private static double rombergIntegration(Function<Double, Double> function,
			double lowerLimit, double upperLimit, int maxSteps, double tolerance) {
		
		double[][] row = new double[maxSteps + 1][maxSteps + 1];
		
		double stepSize = upperLimit - lowerLimit;
		row[0][0] = 0.5 * stepSize * ( function.apply(lowerLimit) + function.apply(upperLimit) );
		
		for ( int i = 1; i <= maxSteps; i++ ) {
	        stepSize /= 2.0;
	        double sum = 0.0;
	        final int newPointCount = 1 << ( i - 1 );
	        for ( int k = 1; k <= newPointCount; k++ ) {
	            final double x = lowerLimit + ( 2 * k - 1 ) * stepSize;
	            sum += function.apply(x);
	        }
	        row[i][0] = 0.5 * row[i - 1][0] + sum * stepSize;

	        for ( int j = 1; j <= i; j++ ) {
	            final double factor = Math.pow(4.0, j);
	            row[i][j] = ( factor * row[i][j - 1] - row[i - 1][j - 1] ) / ( factor - 1.0 );
	        }

	        if ( Math.abs(row[i][i] - row[i - 1][i - 1] ) < tolerance ) {
	            return row[i][i];
	        }
	    }
	
		return row[maxSteps][maxSteps];
	}

}
