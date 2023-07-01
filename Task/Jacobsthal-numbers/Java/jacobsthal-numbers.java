import java.math.BigInteger;

public final class JacobsthalNumbers {

	public static void main(String[] aArgs) {
		System.out.println("The first 30 Jacobsthal Numbers:");
		for ( int i = 0; i < 6; i++ ) {
			for ( int k = 0; k < 5; k++ ) {
				System.out.print(String.format("%15s", jacobsthalNumber(i * 5 + k)));
			}
			System.out.println();
		}
		System.out.println();
		
		System.out.println("The first 30 Jacobsthal-Lucas Numbers:");
		for ( int i = 0; i < 6; i++ ) {
			for ( int k = 0; k < 5; k++ ) {
				System.out.print(String.format("%15s", jacobsthalLucasNumber(i * 5 + k)));
			}
			System.out.println();
		}
		System.out.println();		
		
		System.out.println("The first 20 Jacobsthal oblong Numbers:");
		for ( int i = 0; i < 4; i++ ) {
			for ( int k = 0; k < 5; k++ ) {
				System.out.print(String.format("%15s", jacobsthalOblongNumber(i * 5 + k)));
			}
			System.out.println();
		}
		System.out.println();		
		
		System.out.println("The first 10 Jacobsthal Primes:");
		for ( int i = 0; i < 10; i++ ) {
			System.out.println(jacobsthalPrimeNumber(i));
		}
	}
	
	private static BigInteger jacobsthalNumber(int aIndex) {
		BigInteger value = BigInteger.valueOf(parityValue(aIndex));
		return BigInteger.ONE.shiftLeft(aIndex).subtract(value).divide(THREE);
	}
	
	private static long jacobsthalLucasNumber(int aIndex) {
		return ( 1 << aIndex ) + parityValue(aIndex);
	}
	
	private static long jacobsthalOblongNumber(int aIndex) {
		long nextJacobsthal =  jacobsthalNumber(aIndex + 1).longValueExact();
		long result = currentJacobsthal * nextJacobsthal;
		currentJacobsthal = nextJacobsthal;		
		return result;
	}
	
	private static long jacobsthalPrimeNumber(int aIndex) {
		BigInteger candidate = jacobsthalNumber(latestIndex++);
		while ( ! candidate.isProbablePrime(CERTAINTY) ) {
			candidate = jacobsthalNumber(latestIndex++);
		}		
		return candidate.longValueExact();		
	}
	
	private static int parityValue(int aIndex) {
		return ( aIndex & 1 ) == 0 ? +1 : -1;
	}
	
	private static long currentJacobsthal = 0;
	private static int latestIndex = 0;
	
	private static final BigInteger THREE = BigInteger.valueOf(3);
	private static final int CERTAINTY = 20;
}
