public final class NumbersKWhoseDivisorSumIsEqualToTheDivisorSumOfKPlus1 {

	public static void main(String[] args) {
		final int limit = 500_000;
		int[] divisorSums = new int[limit + 1];
		for ( int i = 1; i <= limit; i++ ) {
			for ( int j = i; j <= limit; j += i ) {
				divisorSums[j] += i;
			}
		}
		
		int count = 0;
		for ( int i = 0; i < limit; i++ ) {
			if ( divisorSums[i] == divisorSums[i + 1] ) {
				System.out.println(++count + ": " + i);
			}
		}
	}

}
