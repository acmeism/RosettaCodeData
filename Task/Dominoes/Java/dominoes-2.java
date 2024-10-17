import java.math.BigInteger;

public final class DominosExtraCredit {

	public static void main(String[] args) {
		BigInteger arrangements = BigInteger.valueOf(dominoTilingCount(7, 8));
		BigInteger permutations = factorial(BigInteger.valueOf(28));
		BigInteger flips = BigInteger.TWO.pow(28);
		
		System.out.println("Arrangements ignoring values: " + arrangements);
		System.out.println("Permutations of 28 dominos: " + permutations);
		System.out.println("Permuted arrangements ignoring flipping dominos: "
						   + permutations.multiply(arrangements));
		System.out.println("Possible flip configurations: " + flips);
		System.out.println("Possible permuted arrangements with flips: "
						   + permutations.multiply(flips).multiply(arrangements));
	}
	
	private static int dominoTilingCount(int rows, int cols) {
	    double product = 1.0;
	    for ( int i = 1; i <= ( rows + 1 ) / 2; i++ ) {
	    	for ( int j = 1; j <= ( cols + 1 ) / 2; j++ ) {
	    		final double cosRows = Math.cos(Math.PI * i / ( rows + 1 ));
	    		final double cosCols = Math.cos(Math.PI * j / ( cols + 1 ));
	    		product *= ( cosRows * cosRows + cosCols * cosCols ) * 4;
	    	}
	    }
	    return (int) product;
	}
	
	private static BigInteger factorial(BigInteger number) {
		if ( number.equals(BigInteger.TWO) ) {
			return number;
		}
		return number.multiply(factorial(number.subtract(BigInteger.ONE)));
	}

}
