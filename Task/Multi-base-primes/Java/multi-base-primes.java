import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public final class MultibasePrimes {

	public static void main(String[] aArgs) {
		final int maxBase = 36;
		final int maxLength = 5;	
		fillPrimes(maxBase, maxLength);		
		multibasePrimes(maxBase, maxLength);		
	}		
	
	private static void multibasePrimes(int aMaxBase, int aMaxLength) {
		for ( int length = 1; length <= aMaxLength; length++ ) {	
	        int maxBasesCount = 0;
	        List<Tuple> maxStrings = new ArrayList<Tuple>();
	        List<Integer> digits = new ArrayList<Integer>(Collections.nCopies(length, 0));
	        digits.set(0, 1);
	        List<Integer> bases = new ArrayList<Integer>();
	
	        do {
	            final int maxDigit = digits.stream().max(Integer::compare).get();
	            final int minBase = Math.max(2, maxDigit + 1);
	            if ( maxBasesCount > aMaxBase - minBase + 1 ) {
	                continue;
	            }
	            bases.clear();
	
	            for ( int base = minBase; base <= aMaxBase; base++ ) {
	                if ( aMaxBase - base + 1 + bases.size() < maxBasesCount ) {
	                    break;
	                }
	                int number = 0;
	                for ( int digit : digits ) {
	                    number = number * base + digit;
	                }
	                if ( primes[number] ) {
	                    bases.add(base);
	                }
	            }
	
	            if ( bases.size() > maxBasesCount ) {
	                maxBasesCount = bases.size();
	                maxStrings.clear();
	            }
	            if ( bases.size() == maxBasesCount ) {
	                maxStrings.add( new Tuple( new ArrayList<Integer>(digits), new ArrayList<Integer>(bases) ) );
	            }
	
	        } while ( increment(digits, aMaxBase) );
	
	        System.out.println(length + "-character strings which are prime in the most bases: " + maxBasesCount);
	        for ( Tuple tuple : maxStrings ) {
	            System.out.println(numberBase(tuple.first) + " -> " + tuple.second);
	        }
	        System.out.println();
	    }
	}
	
	private static boolean increment(List<Integer> aDigits, int aMaxBase) {
	    for ( int i = aDigits.size() - 1; i >= 0; i-- ) {
	        if ( aDigits.get(i) + 1 != aMaxBase ) {
	            aDigits.set(i, aDigits.get(i) + 1);	
	            return true;
	        }
	        aDigits.set(i, 0);
	    }
	    return false;
	}
	
	private static String numberBase(List<Integer> aList) {
	    final String digits = "0123456789abcdefghijklmnopqrstuvwxyz";
	    StringBuilder result = new StringBuilder();
	    for ( int number : aList ) {
	        result.append(digits.charAt(number));
	    }
	    return result.toString();
	}
	
	private static void fillPrimes(int aMaxBase, int aMaxLength) {
		final int limit = (int) Math.pow(aMaxBase, aMaxLength);
		primes = new boolean[limit + 1];
		Arrays.fill(primes, true);
		primes[0] = false;
		primes[1] = false;
		for ( int i = 2; i < Math.sqrt(limit); i++ ) {
			if ( primes[i] ) {
				int j = i * i;
				while ( j <= limit ) {
					primes[j] = false;
					j += i;
				}
			}
		}
	}
	
	private static class Tuple {
		
		public Tuple(List<Integer> aFirst, List<Integer> aSecond) {
			first = aFirst; second = aSecond;
		}
		
		private List<Integer> first, second;		
		
	}
	
	private static boolean[] primes;
	
}
