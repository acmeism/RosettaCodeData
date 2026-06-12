import java.util.stream.IntStream;

public final class InconsummateNumbersInBase10 {

	public static void main(String[] args) {
		createIsConsummate();
		int[] inconsummates = IntStream.rangeClosed(0, sieveSize).filter( i -> ! isConsummate[i] ).toArray();
		
		System.out.println("The first 50 inconsummate numbers in base 10:");
		for ( int i = 1; i <= 50; i++ ) {
			System.out.print(String.format("%3d%s", inconsummates[i], ( i % 10 == 0 ? "\n" : " " )));
		}
		System.out.println();
		System.out.println("The 1,000 inconsummate number is " + inconsummates[1_000]);
	}
	
	private static void createIsConsummate() {
		isConsummate = new boolean[sieveSize + 1];
		for ( int n = 1; n < maximum; n++ ) {
			int digitalSum = digitalSum(n);
			if ( n % digitalSum == 0 ) {
				int quotient = n / digitalSum;
				if ( quotient <= sieveSize ) {
					isConsummate[quotient] = true;
				}
			}
		}		
	}
	
	private static int digitalSum(int number) {
		return String.valueOf(number).chars().map( i -> i - (int) '0' ).sum();
	}
	
	private static boolean[] isConsummate;
	
	private static final int sieveSize = 10_000;
	private static final int maximum = 9 * String.valueOf(sieveSize).length() * sieveSize;
	
}
