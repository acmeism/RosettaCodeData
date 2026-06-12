import java.util.Arrays;

public final class MosersCircleProblem {

	public static void main(String... args) {
		final int limit = 20;
		
	    IO.println("The first 20 values of Moser's circle problem calculated in different ways:");
	
	    IO.println("\nDirect calculation of a 4th order equation:");
	    Arrays.stream(moserDirect(limit)).forEach( i -> IO.print(i + " ") );
		
		IO.println("\n\nUsing binomial sums:");
		for ( int i = 1; i <= limit; i++ ) {
			IO.print(( binomial(i, 4) + binomial(i, 2) + 1 ) + " ");
		}
		
		IO.println("\n\nUsing a binomial transform:");
		Arrays.stream(binomialTransform(limit)).forEach( i -> IO.print(i + " ") );

		IO.print("\n\nPartial sums of Pascals triangle:\n");
		Arrays.stream(pascalsTrianglePartialSums(limit)).forEach( i -> IO.print(i + " ") );
	}
	
	private static int[] pascalsTrianglePartialSums(int limit) {
		int[][] pascal = new int[limit][limit];
		for ( int row = 0; row < limit; row++ ) {
			pascal[row][0] = 1;
			for ( int col = 1; col <= row; col++ ) {
				pascal[row][col] = pascal[row - 1][col - 1] + pascal[row - 1][col];
			}
		}
		
		int [] result = new int[limit];
		for ( int row = 0; row < limit; row++ ) {
			result[row] = 0;
			// Partial sum of the first 5 columns
			for ( int col = 0; col < 5; col++ ) {
				result[row] += pascal[row][col];
			}
		}
		return result;
	}	
	
	private static int[] binomialTransform(int limit) {
		int[] result = new int[limit];
		for ( int n = 0; n < limit; n++ ) {
			int sum = 0;
			for ( int k = 0; k <= n; k++ ) {
				sum += ( k < 5 ) ? binomial(n, k) : 0;
			}
			result[n] = sum;
		}
		return result;
	}
	
	private static int binomial(int n, int k) {
		if ( k < 0 || k > n ) {
			return 0;
		}
		
		int result = 1;
		for ( int i = 1; i <= k; i++ ) {
			result = result * ( n - i + 1 ) / i;
		}
		return result;
	}
	
	private static int[] moserDirect(int limit) {
		int[] result = new int[limit];
		for ( int i = 1; i <= limit; i++ ) {
			result[i - 1] = ( i * i * i * i - 6 * i * i * i + 23 * i * i - 18 * i + 24 ) / 24;
		}
		return result;
	}

}
