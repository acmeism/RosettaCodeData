import java.util.Arrays;

public final class BinomialTransform {

	public static void main(String[] args) {
		long[][] sequences = new long[][] {
		    { 1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845 },
		    { 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0 },
		    { 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181 },
		    { 1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37 }
		};

		String[] names = new String[] {
		    "Catalan number sequence:",
			"Prime flip-flop sequence:",
			"Fibonacci number sequence:",
			"Padovan number sequence:"
		};
		
		for ( int i = 0; i < sequences.length; i++ ) {
			System.out.println(names[i]);
			System.out.println(Arrays.toString(sequences[i]));
			System.out.println("Forward binomial transform:");
			System.out.println(Arrays.toString(forward(sequences[i])));
			System.out.println("Inverse binomial transform:");
			System.out.println(Arrays.toString(inverse(sequences[i])));
			System.out.println("Round trip:");
			System.out.println(Arrays.toString(inverse(forward(sequences[i]))));
			System.out.println("Self-inverting:");
			System.out.println(Arrays.toString(self_inverting(sequences[i])));
			System.out.println("Round trip self-inverting:");
			System.out.println(Arrays.toString(self_inverting(self_inverting(sequences[i]))));
			System.out.println();
		}

	}
	
	private static long[] self_inverting(long[] numbers) {
		long[] transform = new long[numbers.length];
	    for ( int n = 0; n < numbers.length; n++ ) {
	        for ( int k = 0; k <= n; k++ ) {
	            final int sign = ( k % 2 == 1 ) ? -1 : 1;
	            transform[n] += binomial(n, k) * numbers[k] * sign;
	        }
	    }
	    return transform;
	}
	
	private static long[] inverse(long[] numbers) {
		long[] transform = new long[numbers.length];
	    for ( int n = 0; n < numbers.length; n++ ) {
	        for ( int k = 0; k <= n; k++ ) {
	            final int sign = ( ( n - k ) % 2 == 1 ) ? -1 : 1;
	            transform[n] += binomial(n, k) * numbers[k] * sign;
	        }
	    }
	    return transform;
	}
	
	private static long[] forward(long[] numbers) {
		long[] transform = new long[numbers.length];
	    for ( int n = 0; n < numbers.length; n++ ) {
	        for ( int k = 0; k <= n; k++ ) {
	            transform[n] += binomial(n, k) * numbers[k];
	        }
	    }
	    return transform;
	}	

	private static long binomial(int n, int k) {
		return factorial(n) / factorial(n - k) / factorial(k);
	}

	private static long factorial(int number) {
	    if ( number > 20 ) {
	    	throw new AssertionError("Factorial of number is too large: " + number);
	    }
	    if ( number < 2 ) {
	    	return 1;
	    }
	
	    long factorial = 1;
	    for ( int i = 2; i <= number; i++ ) {
	    	factorial *= i;
	    }
	    return factorial;
	}

}
