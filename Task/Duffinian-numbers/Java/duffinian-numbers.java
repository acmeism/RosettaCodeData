import java.util.Arrays;

public final class DuffianNumbers {

	public static void main(String[] aArgs) {
		int[] duffians = createDuffians(11_000);
		
		System.out.println("The first 50 Duffinian numbers:");
		int count = 0;
		int n = 1;
		while ( count < 50 ) {
			if ( duffians[n] > 0 ) {
				System.out.print(String.format("%4d%s", n, ( ++count % 25 == 0 ? "\n" : "" )));
			}
			n += 1;				
		}
		System.out.println();
		
		System.out.println("The first 16 Duffinian triplets:");
		count = 0;
		n = 3;
		while( count < 16 ) {
		    if ( duffians[n - 2] > 0 && duffians[n - 1] > 0 && duffians[n] > 0 ) {
		    	System.out.print(String.format("%22s%s",
		    		"(" + ( n - 2 ) + ", " + ( n - 1 ) + ", " + n + ")", ( ++count % 4 == 0 ? "\n" : "" )));
		    }
		    n += 1;
		}
		System.out.println();
	}
	
	private static int[] createDuffians(int aLimit) {
		// Create a list where list[i] is the divisor sum of i.
		int[] result = new int[aLimit];
		Arrays.fill(result, 1);
		for ( int i = 2; i < aLimit; i++ ) {
			for ( int j = i; j < aLimit; j += i ) {
				result[j] += i;
			}
		}		
		
		// Set the divisor sum of non-Duffinian numbers to 0.
		result[1] = 0; //  1 is not a Duffinian number.
		for ( int n = 2; n < aLimit; n++ ) {
			int resultN = result[n];
		    if ( resultN == n + 1 || gcd(n, resultN) != 1 ) {
		    	// n is prime, or it is not relatively prime to its divisor sum.
		    	result[n] = 0;
		    }
		}	
		return result;
	}
	
	private static int gcd(int aOne, int aTwo) {
		if ( aTwo == 0 ) {
			return aOne;
		}
		return gcd(aTwo, aOne % aTwo);
	}

}
