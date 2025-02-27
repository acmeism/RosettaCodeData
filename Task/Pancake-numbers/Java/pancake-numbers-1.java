public final class PancakeNumbersApproximation {
	
	public static void main(String[] args) {
        for ( int i = 0; i < 4; i++ ) {
            for ( int j = 1; j < 6; j++ ) {
                final int n = 5 * i + j;
                System.out.print(String.format("%s%2d%s%d%s", "p(", n, ") = ", pancake(n), "\t"));
            }
            System.out.println();
        }
    }
	
    private static int pancake(int number) {
    	int gap = 2;
    	int previousGap = 1;
    	int sumGaps = gap;
    	int adjustment = -1;
    	
	    while ( sumGaps < number ) {
	        adjustment += 1;
	        final int previousGapCopy = previousGap;
	        previousGap = gap;
	        gap += previousGapCopy;
	        sumGaps += gap;
	    }
	
	    number += adjustment;
	    return number;
    }

}
