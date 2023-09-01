public final class MagicConstant {

	public static void main(String[] aArgs) {
		System.out.println("The first 20 magic constants:");
		for ( int i = 1; i <= 20; i++ ) {
			System.out.print(" " + magicConstant(order(i)));
		}
		System.out.println(System.lineSeparator());
		
		System.out.println("The 1,000th magic constant: " + magicConstant(order(1_000)) + System.lineSeparator());
		
		System.out.println("Order of the smallest magic square whose constant is greater than:");
		for ( int i = 1; i <= 20; i++ ) {
			String powerOf10 = "10^" + i + ":";
			System.out.println(String.format("%6s%8s", powerOf10, minimumOrder(i)));
		}
	}
	
	// Return the magic constant for a magic square of the given order
	private static int magicConstant(int aN) {	
		return aN * ( aN * aN + 1 ) / 2;
	}

	// Return the smallest order of a magic square such that its magic constant is greater than 10 to the given power
	private static int minimumOrder(int aN) {		
		return (int) Math.exp( ( LN2 + aN * LN10 ) / 3 ) + 1;
	}
	
	// Return the order of the magic square at the given index
	private static int order(int aIndex) {
		return ORDER_FIRST_MAGIC_SQUARE + aIndex - 1;
	}
	
    private static final int ORDER_FIRST_MAGIC_SQUARE = 3;
	private static final double LN2 = Math.log(2.0);
	private static final double LN10 = Math.log(10.0);

}
