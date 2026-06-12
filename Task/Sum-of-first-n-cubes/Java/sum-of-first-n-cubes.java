public final class SumOfFirstNCubes {
	
	public static void main(String[] args) {
		int sum = 0;
		for ( int n = 0; n < 50; n++ ) {
			sum += n * n * n;
			System.out.print("%7d %s".formatted(sum, ( n % 10 == 9 ? "\n" : " " )));
		}				
	}

}
