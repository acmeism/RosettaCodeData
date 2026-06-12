public final class CombinationsWithRepetionsSquareDigitChain {

	public static void main(String[] args) {
		int[] items = new int[] { 7, 8, 11, 14, 17 };
	    for ( int k : items ) {
	        long[] sums = new long[k * 81 + 1];
	        sums[0] = 1;
	        sums[1] = 0;
	        for ( int n = 1; n <= k; n++ ) {
	            for ( int i = n * 81; i >= 1; i-- ) {
	                for ( int j = 1; j <= 9; j++ ) {
	                    final int s = j * j;
	                    if ( s > i ) {
	                    	break;
	                    }
	                    sums[i] += sums[i - s];
	                }
	            }
	        }
	
	        long countOnes = 0;
	        for ( int i = 1; i <= k * 81; i++ ) {
	        	if ( endsWithOne(i) ) {
	        		countOnes += sums[i];
	        	}
	        }
	
	        final long limit = (long) Math.pow(10, k) - 1;
	        System.out.println("For k = " + k + " in the range 1 to " + limit);
	        System.out.println(countOnes + " numbers produce 1 and " + ( limit - countOnes ) + " numbers produce 89");
	        System.out.println();
	    }
	}
	
	private static boolean endsWithOne(int number) {
	    int sum = 0;
	    while ( true ) {
	        while ( number > 0 ) {
	            int digit = number % 10;
	            sum += digit * digit;
	            number /= 10;
	        }
	
	        if ( sum == 1 ) {
	        	return true;
	        }
	        if ( sum == 89 ) {
	        	return false;
	        }
	        number = sum;
	        sum = 0;
	    }
	}

}
