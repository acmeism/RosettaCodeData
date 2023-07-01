import java.math.BigInteger;

public final class UltraUsefulPrimes {

	public static void main(String[] args) {
		for ( int n = 1; n <= 10; n++ ) {
			showUltraUsefulPrime(n);
		}		
	}
	
	private static void showUltraUsefulPrime(int n) {
		BigInteger prime = BigInteger.ONE.shiftLeft(1 << n);
		BigInteger k = BigInteger.ONE;
		while ( ! prime.subtract(k).isProbablePrime(20) ) {
			k = k.add(BigInteger.TWO);
		}
		
		System.out.print(k + " ");		
	}

}
