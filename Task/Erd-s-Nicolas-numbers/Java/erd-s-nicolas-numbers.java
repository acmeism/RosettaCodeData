import java.util.Arrays;

public final class ErdosNicolasNumbers {

	public static void main(String[] aArgs) {
		final int limit = 100_000_000;
		
	    int[] divisorSum = new int[limit + 1];
	    int[] divisorCount = new int[limit + 1];
	    Arrays.fill(divisorSum, 1);
	    Arrays.fill(divisorCount, 1);
	
	    for ( int index = 2; index <= limit / 2; index++ ) {
	        for ( int number = 2 * index; number <= limit; number += index ) {
	            if ( divisorSum[number] == number ) {
	                System.out.println(String.format("%8d", number) + " equals the sum of its first "
	                	             + String.format("%3d", divisorCount[number]) + " divisors");
	            }
	
	            divisorSum[number] += index;
	            divisorCount[number]++;
	        }
	    }
	}

}
