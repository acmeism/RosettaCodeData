import java.util.ArrayList;
import java.util.List;

public final class CyclopsNumbers {

	public static void main(String[] args) {
		List<Integer> cyclops = new ArrayList<Integer>();
		List<Integer> primeCyclops = new ArrayList<Integer>();
		List<Integer> blindPrimeCyclops = new ArrayList<Integer>();
		List<Integer> palindromicPrimeCyclops = new ArrayList<Integer>();
		
		List<List<Integer>> ranges = List.of( List.of( 0, 0), List.of( 101, 909),
			List.of( 11011, 99099 ), List.of( 1110111, 9990999 ), List.of( 111101111, 119101111 ) );
		
		for ( List<Integer> range : ranges) {
			for ( int i = range.getFirst(); i <= range.getLast(); i++ ) {
				String value = String.valueOf(i);
				if ( isCyclopsNumber(value) ) {
					cyclops.addLast(i);
					if ( isPrime(i) ) {
						primeCyclops.addLast(i);
						if ( isBlind(value) ) {
							blindPrimeCyclops.addLast(i);
						}
						if ( isPalindromic(value) ) {
							palindromicPrimeCyclops.addLast(i);
						}
					}
				}
			}
		}		
		
		System.out.println("The first 50 Cyclops numbers:");
		for ( int i = 0; i < 50; i++ ) {
			System.out.print(String.format("%6s%s", cyclops.get(i), ( i % 10 == 9 ? "\n" : "" )));
		}
		System.out.println();
		int firstIndex = firstIndex(cyclops);
		System.out.println("The first cyclops number greater than ten million is "
			+ cyclops.get(firstIndex) + " at zero based index " + firstIndex);
		System.out.println();
		
		System.out.println("The first 50 prime Cyclops numbers:");
		for ( int i = 0; i < 50; i++ ) {
			System.out.print(String.format("%7s%s", primeCyclops.get(i), ( i % 10 == 9 ? "\n" : "" )));
		}
		System.out.println();
		firstIndex = firstIndex(primeCyclops);
		System.out.println("The first prime cyclops number greater than ten million is "
			+ primeCyclops.get(firstIndex) + " at zero based index " + firstIndex);
		System.out.println();
		
		System.out.println("The first 50 blind prime Cyclops numbers:");
		for ( int i = 0; i < 50; i++ ) {
			System.out.print(String.format("%7s%s", blindPrimeCyclops.get(i), ( i % 10 == 9 ? "\n" : "" )));
		}
		System.out.println();
		firstIndex = firstIndex(blindPrimeCyclops);
		System.out.println("The first blind prime cyclops number greater than ten million is "
			+ blindPrimeCyclops.get(firstIndex) + " at zero based index " + firstIndex);
		System.out.println();
		
		System.out.println("The first 50 palindromic prime Cyclops numbers:");
		for ( int i = 0; i < 50; i++ ) {
			System.out.print(
                String.format("%9s%s", palindromicPrimeCyclops.get(i), ( i % 10 == 9 ? "\n" : "" )));
		}
		System.out.println();
		firstIndex = firstIndex(palindromicPrimeCyclops);
		System.out.println("The first palindromic prime cyclops number greater than ten million is "
			+ palindromicPrimeCyclops.get(firstIndex) + " at zero based index " + firstIndex);
		System.out.println();		
	}	
	
	private static int firstIndex(List<Integer> numbers) {
		int start = 0;
		int end = numbers.size() - 1;
		while ( start <= end ) {
	        final int mid = start + ( end - start ) / 2;
	        if ( numbers.get(mid) <= 10_000_000 ) {
	            start = mid + 1;
	        } else {
	            end = mid - 1;
	        }
	    }
	    return start;
	}	
	
	private static boolean isCyclopsNumber(String text) {
		return text.charAt(text.length() / 2) == '0' && text.indexOf('0') == text.lastIndexOf('0');
	}
	
	private static boolean isPalindromic(String text) {
		for ( int i = 0; i < text.length() / 2; i++ ) {
			if ( text.charAt(i) != text.charAt(text.length() - 1 - i) ) {
				return false;
			}
		}
		return true;
	}
	
	private static boolean isBlind(String text) {
		final int middle = text.length() / 2;
		final String withoutZero = text.substring(0, middle) + text.substring(middle + 1);
		return isPrime(Integer.valueOf(withoutZero));
	}
	
	private static boolean isPrime(int number) {
	    if ( number < 2 ) {
	    	return false;
	    }
	    if ( number % 2 == 0 ) {
	    	return number == 2;
	    }
	    if ( number % 3 == 0 ) {
	    	return number == 3;
	    }
	    int k = 5;
	    while ( k * k <= number ) {
	    	if ( number % k == 0 ) {
	    		return false;
	    	}
	    	k += 2;
	    	if ( number % k == 0 ) {
	    		return false;
	    	}
	    	k += 4;
	    }
	    return true;
	}
	
}
