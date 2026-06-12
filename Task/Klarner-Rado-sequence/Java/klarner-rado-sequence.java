public final class KlarnerRadoSequence {

	public static void main(String[] args) {
		final int limit = 1_000_000;
		int[] klarnerRado = initialiseKlarnerRadoSequence(limit);
		
		System.out.println("The first 100 elements of the Klarner-Rado sequence:");
		for ( int i = 1; i <= 100; i++ ) {
			System.out.print(String.format("%3d%s", klarnerRado[i], ( i % 10 == 0 ? "\n" : " " )));
		}
		System.out.println();

		int index = 1_000;
		while ( index <= limit ) {
			System.out.println("The " + index + "th element of Klarner-Rado sequence is " + klarnerRado[index]);
		  	index *= 10;
		}
	}
	
	private static int[] initialiseKlarnerRadoSequence(int limit) {
		int[] result = new int[limit + 1];
		int i2 = 1, i3 = 1;
		int m2 = 1, m3 = 1;
		for ( int i = 1; i <= limit; i++ ) {
		   int minimum = Math.min(m2, m3);
		   result[i] = minimum;;
		   if ( m2 == minimum ) {
		      m2 = result[i2] * 2 + 1;
		      i2 += 1;
		   }
		   if ( m3 == minimum ) {
		      m3 = result[i3] * 3 + 1;
		      i3 += 1;
		   }
		}
		return result;
	}

}
