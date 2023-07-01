import java.math.BigInteger;

public final  class CullenAndWoodhall {

	public static void main(String[] aArgs) {
		numberSequence(20, NumberType.Cullen);
		
		numberSequence(20, NumberType.Woodhall);
		
		primeSequence(5, NumberType.Cullen);
		
		primeSequence(12, NumberType.Woodhall);
	}

	private enum NumberType { Cullen, Woodhall }
	
	private static void numberSequence(int aCount, NumberType aNumberType) {
		System.out.println();
		System.out.println("The first " + aCount + " " + aNumberType + " numbers are:");
		numberInitialise();
		for ( int index = 1; index <= aCount; index++ ) {
			System.out.print(nextNumber(aNumberType) + " ");
		}	
		System.out.println();	
	}
	
	private static void primeSequence(int aCount, NumberType aNumberType) {
		System.out.println();
		System.out.println("The indexes of the first " + aCount + " " + aNumberType + " primes are:");
		primeInitialise();
		
		while ( count < aCount ) {			
			if ( nextNumber(aNumberType).isProbablePrime(CERTAINTY) ) {
				System.out.print(primeIndex + " ");
				count += 1;
			}
			
			primeIndex += 1;
		}
		System.out.println();
	}
	
	private static BigInteger nextNumber(NumberType aNumberType) {
		number = number.add(BigInteger.ONE);
		power = power.shiftLeft(1);
		return switch ( aNumberType ) {
			case Cullen -> number.multiply(power).add(BigInteger.ONE);
			case Woodhall -> number.multiply(power).subtract(BigInteger.ONE);
		};
	}
	
	private static void numberInitialise() {
		number = BigInteger.ZERO;
		power = BigInteger.ONE;		
	}
	
	private static void primeInitialise() {	
		count = 0;
		primeIndex = 1;
		numberInitialise();
	}
	
	private static BigInteger number;
	private static BigInteger power;
	private static int count;
	private static int primeIndex;
	
	private static final int CERTAINTY = 20;
	
}
