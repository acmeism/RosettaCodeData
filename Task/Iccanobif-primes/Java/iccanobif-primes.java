import java.math.BigInteger;

public final class IccanobifPrimes {

	public static void main(String[] args) {
		System.out.println("The first 25 Iccanobif primes:");
		int count = 0;
		while ( count < 25 ) {
			BigInteger fibonacci = nextFibonacci();
			BigInteger reversed = reversed(fibonacci);
		    if ( reversed.isProbablePrime(20) ) {
		    	count += 1;
		    	String number = reversed.toString();
		    	System.out.println(
		    		String.format("%2d%s%s%s", count, ": ", compressed(number, 20), digitCount(number)));
		    }
		}
	}
	
	private static BigInteger nextFibonacci() {
		current = current.add(previous);
		previous = current.subtract(previous);
		return current;
	}
	
	private static String compressed(String number, int size) {
		if ( number.length() <= 2 * size ) {
			return number;
		}		
		return number.substring(0, size) + " ... " + number.substring(number.length() - size);
	}
	
	private static BigInteger reversed(BigInteger number) {
		String num = number.toString();
		String reversed = new StringBuilder(num).reverse().toString();
		return new BigInteger(reversed);
	}
	
	private static String digitCount(String number) {
		return " ( " + number.length() + ( number.length() == 1 ? " digit " : " digits " ) + ")";
	}
	
	private static BigInteger previous = BigInteger.ONE;
	private static BigInteger current = BigInteger.ONE;

}
