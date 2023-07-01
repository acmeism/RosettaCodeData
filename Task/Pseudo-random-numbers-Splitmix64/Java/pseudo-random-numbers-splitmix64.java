import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.MathContext;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class PseudoRandomSplitmix64 {

	public static void main(String[] aArgs) {
		Splitmix64 random = new Splitmix64();
		random.seed(1234567);
		for ( int i = 0; i < 5; i++ ) {
			System.out.println(random.nextInt());
		}
		
		List<Integer> counts = new ArrayList<Integer>(Collections.nCopies(5, 0));
		
		Splitmix64 rand = new Splitmix64(987654321);
	    for ( int i = 0; i < 100_000; i++ ) {	    	
	        BigDecimal value = rand.nextFloat();
	        final int count = value.multiply(BigDecimal.valueOf(5.0)).toBigInteger().intValue();
	        counts.set(count, counts.get(count) + 1);
	    }
	
	    System.out.println(System.lineSeparator() + "The counts for 100,000 repetitions are: ");
	    for ( int i = 0; i < 5; i++ ) {
	    	System.out.print(i + ": " + counts.get(i) + "   ");
	    }
	    System.out.println();
    }
	
}

final class Splitmix64 {
	
	public Splitmix64() {
		state = BigInteger.ZERO;
	}
	
	public Splitmix64(long aSeed) {
		state = BigInteger.valueOf(aSeed).and(mask64);
	}
	
	public void seed(long aNumber) {
		state = BigInteger.valueOf(aNumber);
	}
	
	public BigInteger nextInt() {
		state = state.add(constant1).and(mask64);
        BigInteger z = state;
        z = z.xor(z.shiftRight(30)).multiply(constant2).and(mask64);
        z = z.xor(z.shiftRight(27)).multiply(constant3).and(mask64);
        BigInteger result = z.xor(z.shiftRight(31)).and(mask64);

        return result;
	}
	
	public BigDecimal nextFloat() {
		return new BigDecimal(nextInt()).divide(twoPower64, MathContext.DECIMAL64);
	}
	
	private BigInteger state;
	
	private final BigInteger constant1 = new BigInteger("9e3779b97f4a7c15", 16);
	private final BigInteger constant2 = new BigInteger("bf58476d1ce4e5b9", 16);
	private final BigInteger constant3 = new BigInteger("94d049bb133111eb", 16);
	private final BigInteger mask64 = BigInteger.ONE.shiftLeft(64).subtract(BigInteger.ONE);
	private final BigDecimal twoPower64 = new BigDecimal(BigInteger.ONE.shiftLeft(64));

}
