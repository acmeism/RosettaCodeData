import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class IntegerLongDivision {

	public static void main(String[] args) {
		List<List<String>> tests = List.of(
			List.of( "0", "1" ), List.of( "1", "1" ), List.of( "1", "3" ), List.of( "1", "7" ), List.of( "83","60" ),
			List.of( "1", "17" ), List.of( "10", "13" ), List.of( "3227", "555" ),
			List.of( "476837158203125", "9223372036854775808" ), List.of( "1", "149" ), List.of( "1", "5261" )
		);
		
		tests.forEach( test -> {
			BigInteger numer = new BigInteger(test.getFirst());
			BigInteger denom = new BigInteger(test.getLast());
			Tuple tuple = divide(numer, denom);
			String result = tuple.result;
			final int period = tuple.period(); 			
			
			String repetend = result.substring(result.length() - period);
	        if ( repetend.length() > 30 ) {
	        	repetend = repetend.substring(0, 15) + " ... " + repetend.substring(repetend.length() - 15);
	        }
	
	        result = result.substring(0, result.length() - period);
	        String rational = numer.toString() + " / " + denom.toString();
	        System.out.print(String.format("%38s%s%s", rational, " = ", result));
	        if ( period != 0 ) {
	            System.out.print("{" + repetend + "} (period " + period + ")");
	        }
	        System.out.println();
		} );
	}
	
	private static Tuple divide(BigInteger numer, BigInteger denom) {
		if ( numer.signum() < 0 ) {
			throw new AssertionError("m must not be negative.");
		}
		if ( denom.signum() <= 0 ) {
			throw new AssertionError("n must be positive.");
		}
		
		String result = numer.divide(denom).toString() + ".";
		BigInteger carry = numer.mod(denom).multiply(BigInteger.TEN);
		int digitCount = 0;
		Map<BigInteger, Integer> carries = new HashMap<BigInteger, Integer>();
		while ( ! carries.keySet().contains(carry) ) {
			if ( carry.signum() == 0 ) {
	            if ( result.endsWith(".") ) {
	                result = result.substring(0, result.length() - 1);
	            }
	            return new Tuple(result , 0);
	        }
	        carries.put(carry, digitCount++);
	        if ( carry.compareTo(denom) < 0 ) {
	            result += "0";
	            carry = carry.multiply(BigInteger.TEN);
	        } else {
	        	result += carry.divide(denom).toString();
	            carry = carry.mod(denom).multiply(BigInteger.TEN);
	        }
	    }
		
	    return new Tuple(result, digitCount - carries.getOrDefault(carry, 0));	
	}

	private static record Tuple(String result, int period) {}

}
