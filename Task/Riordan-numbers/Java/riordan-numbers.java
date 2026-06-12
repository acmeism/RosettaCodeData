import java.math.BigInteger;
import java.util.List;

public final class RiordanNumbers {

	public static void main(String[] args) {
		final int limit = 10_000;
		final BigInteger THREE = BigInteger.valueOf(3);
		
		BigInteger[] riordans = new BigInteger[limit];
		riordans[0] = BigInteger.ONE;
		riordans[1] = BigInteger.ZERO;
		for ( int n = 2; n < limit; n++ ) {
			BigInteger term = BigInteger.TWO.multiply(riordans[n - 1]).add(THREE.multiply(riordans[n - 2]));
			riordans[n] = BigInteger.valueOf(n - 1).multiply(term).divide(BigInteger.valueOf(n + 1));
		}
		
		System.out.println("The first 32 Riordan numbers:");
	    for ( int i = 0; i < 32; i++ ) {
	    	System.out.print(String.format("%14d%s", riordans[i], ( i % 4 == 3 ? "\n" :" " )));
	    }
	    System.out.println();
	
	    for ( int count : List.of( 1_000, 10_000 ) ) {
	    	int length = riordans[count - 1].toString().length();
	    	System.out.println("The " + count + "th Riordan number has " + length + " digits");
	    }
	}		

}
