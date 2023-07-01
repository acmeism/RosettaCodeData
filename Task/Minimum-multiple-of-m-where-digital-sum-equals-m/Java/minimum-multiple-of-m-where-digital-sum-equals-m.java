public final class MinimumMultipleDigitSum {

	public static void main(String[] aArgs) {
		for ( int n = 1; n <= 70; n++ ) {
			int k = 0;
			while ( digitSum(k += n) != n );
			System.out.print(String.format("%8d%s", k / n, ( n % 10 ) == 0 ? "\n" : " "));
		}
	}
	
	private static int digitSum(int aN) {
		int sum = 0;
		while ( aN > 0 ) {
			sum += aN % 10;
			aN /= 10;
		}
		return sum;
	}

}
