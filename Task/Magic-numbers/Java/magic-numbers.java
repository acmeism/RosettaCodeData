import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class MagicNumbers {

	public static void main(String[] args) {
		List<BigInteger> magicNumbers = polydivisible(10);
		System.out.println("There are " + magicNumbers.size() + " magic numbers.");
		System.out.println("The largest magic number is " + magicNumbers.getLast());
		System.out.println();
		
		List<List<String>> magicLists = magicLists(magicNumbers);
		System.out.println("Count of magic numbers by the number of digits:");
		IntStream.range(0, magicLists.size()).forEach( i ->
		    System.out.println(String.format("%2d%s%5d", i + 1, ":", magicLists.get(i).size())) );
		System.out.println();
		
		System.out.print("Minimally pandigital 1-9 magic numbers: ");
		magicLists.get(8).stream().filter( s -> isMinimallyPandigital(s, "1") ).forEach(System.out::print);
		System.out.println();

		System.out.print("Minimally pandigital 0-9 magic numbers: ");		
		magicLists.get(9).stream().filter( s -> isMinimallyPandigital(s, "0") ).forEach(System.out::print);
	}
	
	private static List<BigInteger> polydivisible(int base) {
		List<BigInteger> magicNumbers = new ArrayList<BigInteger>();
	    List<BigInteger> previousNumbers = IntStream.range(1, base).mapToObj( i -> BigInteger.valueOf(i) )
	    									        .collect(Collectors.toList());
	    List<BigInteger> newNumbers = new ArrayList<BigInteger>();
	    BigInteger digitCount = BigInteger.TWO;
	    while ( ! previousNumbers.isEmpty() ) {
	        magicNumbers.addAll(previousNumbers);
	        for ( BigInteger prev : previousNumbers ) {
	            for ( int j = 0; j < base; j++ ) {
	                BigInteger number = prev.multiply(BigInteger.valueOf(base)).add(BigInteger.valueOf(j));
	                if ( number.mod(digitCount).signum() == 0 ) {
	                    newNumbers.addLast(number);
	                }
	            }
	        }
	        previousNumbers = new ArrayList<BigInteger>(newNumbers);
	        newNumbers = new ArrayList<BigInteger>();
	        digitCount = digitCount.add(BigInteger.ONE);
	    }
	    magicNumbers.addFirst(BigInteger.ZERO);
	    return magicNumbers;
	}
	
	private static List<List<String>> magicLists(List<BigInteger> magicNumbers) {
		List<List<String>> result = new ArrayList<List<String>>();
		magicNumbers.stream().map( i -> i.toString() ).forEach( s -> {
			if ( s.length() > result.size() ) {
				result.addLast( new ArrayList<String>() );
			}
			result.get(s.length() - 1).addLast(s);
		} );
		return result;
	}
	
	private static boolean isMinimallyPandigital(String number, String startDigit) {
		List<String> digits = number.chars().mapToObj( i -> String.valueOf(i - '0') )
								    .distinct().sorted().toList();
		return digits.size() == 10 - Integer.valueOf(startDigit) && digits.getFirst().equals(startDigit);
	}
}
