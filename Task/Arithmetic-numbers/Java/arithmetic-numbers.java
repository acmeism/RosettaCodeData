import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class ArithmeticNumbers {

	public static void main(String[] aArgs) {
		int arithmeticCount = 0;
		int compositeCount = 0;
		int n = 1;
		
		while ( arithmeticCount <= 1_000_000 ) {
		    Set<Integer> factors = factors(n);
		    final int sum = factors.stream().mapToInt(Integer::intValue).sum();
		    if ( sum % factors.size() == 0 ) {
		        arithmeticCount += 1;
		        if ( factors.size() > 2 ) {
		            compositeCount += 1;
		        }
		        if ( arithmeticCount <= 100 ) {
		        	System.out.print(String.format("%3d%s", n, ( arithmeticCount % 10 == 0 ) ? "\n" : " "));
		        }
		        if ( List.of( 1_000, 10_000, 100_000, 1_000_000 ).contains(arithmeticCount) ) {
		        	System.out.println();
		            System.out.println(arithmeticCount + "th arithmetic number is " + n);
		            System.out.println("Number of composite arithmetic numbers <= " + n + ": " + compositeCount);
		        }
		    }
		    n += 1;
		}
	}
	
	private static Set<Integer> factors(int aNumber) {
		Set<Integer> result = Stream.of(1, aNumber).collect(Collectors.toCollection(HashSet::new));
	    int i = 2;
	    int j;
	    while ( ( j = aNumber / i ) >= i ) {
	        if ( i * j == aNumber ) {
	            result.add(i);
	            result.add(j);
	        }
	        i += 1;
	    }
	    return result;
	}

}
