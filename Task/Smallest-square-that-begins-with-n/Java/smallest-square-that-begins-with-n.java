public final class SmallestSquareThatBeginsWithN {

	public static void main(String[] args) {
		int[] smallestSquares = smallestSquares(49);
		for ( int i = 1; i < smallestSquares.length; i++ ) {
			System.out.print("%5d%s".formatted(smallestSquares[i], ( i % 10 == 0 ? "\n" : " " )));
		}
	}
	
	private static int[] smallestSquares(int n) {
		int[] result = new int[n + 1];
	    int found = 0;
	    int square = 1;
	    int delta = 3;
	    while ( found < n ) {
	        int k = square;
	        while ( k > 0 ) {
	            if ( k <= n && result[k] == 0 ) {
	                result[k] = square;
	                found += 1;
	        	}
	            k /= 10;
	        }
	        square += delta;
	        delta += 2;
	    }
	    return result;
	}

}
