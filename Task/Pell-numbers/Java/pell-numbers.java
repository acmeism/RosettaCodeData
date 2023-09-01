import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.MathContext;
import java.util.ArrayList;
import java.util.List;

public final class PellNumbers {

	public static void main(String[] aArgs) {		
		System.out.println("7 Tasks");
		System.out.println("-------");
		System.out.println("Task 1, Pell Numbers: " + pellNumbers(TERM_COUNT));
		System.out.println();
		System.out.println("Task 2, Pell-Lucas Numbers: " + pellLucasNumbers(TERM_COUNT));
		System.out.println();
		System.out.println("Task 3, Approximations to square root of 2:");
		List<Rational> rationals = squareRoot2(TERM_COUNT + 1);
		for ( int i = 1; i < TERM_COUNT + 1; i++ ) {
			System.out.println(rationals.get(i) + " = " + rationals.get(i).toBigDecimal());
		}
		System.out.println();
		List<Pair> pairs = pellPrimes(TERM_COUNT);
		System.out.println("Task 4, Pell primes:");
		for ( int i = 0; i < TERM_COUNT; i++ ) {
			System.out.println(pairs.get(i).pellPrime);
		}
		System.out.println();
		System.out.print("Task 5, Pell indices of Pell primes:");
		for ( int i = 0; i < TERM_COUNT; i++ ) {
			System.out.print(pairs.get(i).index + " ");
		}
		System.out.println();
		System.out.println();
		System.out.println("Task 6, Newman-Shank-Williams numbers: " + newmanShankWilliams(TERM_COUNT));
		System.out.println();		
		System.out.println("Task , Near isoseles right triangles:");
		List<Triple> nearIsoselesRightTriangles = nearIsoslesRightTriangles(TERM_COUNT);
		for ( int i = 0; i < TERM_COUNT; i++ ) {
			System.out.println(nearIsoselesRightTriangles.get(i));
		}		
	}
	
	private static List<BigInteger> pellNumbers(int aTermCount) {
		PellIterator pellIterator = new PellIterator(BigInteger.ZERO, BigInteger.ONE);
		List<BigInteger> result = new ArrayList<BigInteger>();
		for ( int i = 0; i < aTermCount; i++ ) {			
			result.add(pellIterator.next());
		}
		return result;
	}
	
	private static List<BigInteger> pellLucasNumbers(int aTermCount) {
		PellIterator pellLucasIterator = new PellIterator(BigInteger.TWO, BigInteger.TWO);
		List<BigInteger> result = new ArrayList<BigInteger>();
		for ( int i = 0; i < aTermCount; i++ ) {
			result.add(pellLucasIterator.next());
		}
		return result;
	}
	
	private static List<Rational> squareRoot2(int aTermCount) {
		PellIterator pellIterator = new PellIterator(BigInteger.ZERO, BigInteger.ONE);
		PellIterator pellLucasIterator = new PellIterator(BigInteger.TWO, BigInteger.TWO);
		List<Rational> result = new ArrayList<Rational>();
		for ( int i = 0; i < aTermCount; i++ ) {
			result.add( new Rational(pellLucasIterator.next().divide(BigInteger.TWO), pellIterator.next()) );
		}
		return result;		
	}
	
	private static List<Pair> pellPrimes(int aTermCount) {
		PellIterator pellIterator = new PellIterator(BigInteger.ZERO, BigInteger.ONE);
		int index = 0;
		int count = 0;
		List<Pair> result = new ArrayList<Pair>();
		while ( count < aTermCount ) {
			BigInteger pellNumber = pellIterator.next();
			if ( pellNumber.isProbablePrime(16) ) {
				result.add( new Pair(pellNumber, index) );
				count += 1;
			}
			index += 1;		
		}
		return result;
	}
	
	private static List<BigInteger> newmanShankWilliams(int aTermCount) {
		PellIterator pellIterator = new PellIterator(BigInteger.ZERO, BigInteger.ONE);
		List<BigInteger> result = new ArrayList<BigInteger>();
		for ( int i = 0; i < aTermCount; i++ ) {
			BigInteger pellNumber = pellIterator.next();
			result.add(pellNumber.add(pellIterator.next()));
		}		
		return result;
	}
	
	private static List<Triple> nearIsoslesRightTriangles(int aTermCount) {
		PellIterator pellIterator = new PellIterator(BigInteger.ZERO, BigInteger.ONE);
		pellIterator.next();
		List<Triple> result = new ArrayList<Triple>();
		BigInteger sum = pellIterator.next();
		for ( int i = 0; i < aTermCount; i++ ) {
			sum = sum.add(pellIterator.next());
			BigInteger nextTerm = pellIterator.next();
			result.add( new Triple(sum, sum.add(BigInteger.ONE), nextTerm) );
			sum = sum.add(nextTerm);
		}
		return result;
	}
		
	private static class PellIterator {
			
		public PellIterator(BigInteger aFirst, BigInteger aSecond) {
			a = aFirst; b = aSecond;
		}
		
		public BigInteger next() {
			aCopy = a;
			bCopy = b;
			b = b.add(b).add(a);
			a = bCopy;
			return aCopy;
		}
		
		private BigInteger a, aCopy, b, bCopy;
		
	}
	
	private static record Rational(BigInteger numerator, BigInteger denominator) {
		
		public BigDecimal toBigDecimal() {
			return new BigDecimal(numerator).divide( new BigDecimal(denominator), mathContext );
		}
		
		public String toString() {
			return numerator + " / " + denominator;
		}
		
		private static MathContext mathContext = new MathContext(34);
		
	}
	
	private static record Pair(BigInteger pellPrime, int index) {}
	
	private static record Triple(BigInteger shortSide, BigInteger longSide, BigInteger hypotenuse) {
		
		public String toString() {
			return "(" + shortSide + ", " + longSide + ", " + hypotenuse + ")" ;
		}
		
	}
	
	private static final int TERM_COUNT = 10;
	
}
