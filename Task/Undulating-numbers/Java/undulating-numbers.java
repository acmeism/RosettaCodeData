public final class UndulatingNumbers {

	public static void main(String[] args) {		
		// Task - Part 1
		UndulatingNumberIterator iterator = new UndulatingNumberIterator(3, 3, 10);
		System.out.println("Three digit undulating numbers in base 10:");
		int count = 0;
		while ( iterator.hasNext() ) {
		    count += 1;
		    System.out.print(String.format("%3d%s", iterator.next(), ( ( count % 9 == 0 ) ? "\n" : " " )));
		}
		System.out.println();
		
		// Task - Part 2
		iterator = new UndulatingNumberIterator(4, 4, 10);
		System.out.println("Four digit undulating numbers in base 10:");
		count = 0;
		while ( iterator.hasNext() ) {
		    count += 1;
		    System.out.print(String.format("%3d%s", iterator.next(), ( ( count % 9 == 0 ) ? "\n" : " " )));
		}
		System.out.println();
		
		// Task - Part 3
		iterator = new UndulatingNumberIterator(3, 3, 10);
		System.out.println("Three digit undulating numbers in base 10 which are prime numbers:");
		while ( iterator.hasNext() ) {
			long undulatingNumber = iterator.next();
		    if ( isPrime(undulatingNumber) ) {
		    	System.out.print(undulatingNumber + " ");
		    }
		}
		System.out.println(System.lineSeparator());
		
		// Task - Part 4
		iterator = new UndulatingNumberIterator(3, 100, 10);
		count = 0;
		while ( count < 599 && iterator.hasNext() ) {
		    count += 1;
		    iterator.next();
		}
		System.out.println("The 600th undulating number in base 10 is " + iterator.next());
		System.out.println();
		
		// Task - Part 5
		final long TWO_POWER_53 = (long) Math.pow(2, 53);
		final int maxDigitsBase10 = String.valueOf(TWO_POWER_53).length();
		long number = 0;
		long largest = 0;
		count = 0;
		iterator = new UndulatingNumberIterator(3, maxDigitsBase10, 10);
		while ( iterator.hasNext() && ( number = iterator.next() ) < TWO_POWER_53 ) {
		    count += 1;
		    largest = number;
		}
		System.out.println("The number of undulating numbers in base 10 less than 2^53 is " + count);
		System.out.println("The last undulating number in base 10 less than 2^53 is " + largest);
		System.out.println();
		
		// Bonus - Part 1
		System.out.println("Three digit numbers, written in base 10, which are undulating in base 7:");
		iterator = new UndulatingNumberIterator(3, 3, 7);
		count = 0;
		while ( iterator.hasNext() ) {
		    count += 1;
		    System.out.print(String.format("%3d%s", iterator.next(), ( ( count % 9 == 0 ) ? "\n" : " " )));
		}
		System.out.println();
		
		// Bonus - Part 2
		System.out.println("Four digit numbers, written in base 10, which are undulating in base 7:");
		iterator = new UndulatingNumberIterator(4, 4, 7);
		count = 0;
		while ( iterator.hasNext() ) {
		    count += 1;
		    System.out.print(String.format("%3d%s", iterator.next(), ( ( count % 9 == 0 ) ? "\n" : " " )));
		}
		System.out.println();
		
		// Bonus - Part 3
		iterator = new UndulatingNumberIterator(3, 3, 7);
		System.out.println("Three digit prime numbers, written in base 10, which are undulating in base 7:");
		while ( iterator.hasNext() ) {
			long undulatingNumber = iterator.next();
		    if ( isPrime(undulatingNumber) ) {
		    	System.out.print(undulatingNumber + " ");
		    }
		}
		System.out.println(System.lineSeparator());		
		
		// Bonus - Part 4
		iterator = new UndulatingNumberIterator(3, 100, 7);
		count = 0;
		while ( count < 599 && iterator.hasNext() ) {
		    count += 1;
		    iterator.next();
		}
		final long undulatingNumber = iterator.next();
		System.out.println("The 600th undulating number in base 7 is " + convertToBase(7, undulatingNumber));
		System.out.println("which is " + undulatingNumber + " written in base 10");
		System.out.println();
		
		// Task - Part 5
		final int maxDigitsBase7 = convertToBase(7, TWO_POWER_53).length();
		number = 0;
		largest = 0;
		count = 0;
		iterator = new UndulatingNumberIterator(3, maxDigitsBase7, 7);
		while ( iterator.hasNext() && ( number = iterator.next() ) < TWO_POWER_53 ) {
		    count += 1;
		    largest = number;
		}
		System.out.println("The number of undulating numbers in base 7 less than 2^53 is " + count);
		System.out.println("The last undulating number in base 7 less than 2^53 is " + convertToBase(7, largest));
		System.out.println("which is " + largest+ " written in base 10");
		System.out.println();
	}
	
	private static final class UndulatingNumberIterator {
		
		public UndulatingNumberIterator(int aMinDigits, int aMaxDigits, int aBase) {
			minDigits = aMinDigits;
			maxDigits = aMaxDigits;
			base = aBase;
		}
		
		public boolean hasNext() {
			return minDigits <= maxDigits;
		}
		
		public long next() {
	        long result = 0;
	        for ( int digit = 0; digit < minDigits; digit++ ) {
	            result = result * base + ( digit % 2 == 0 ? a : b );
	        }
	
	        b += 1;
	        if ( a == b ) {
	            b += 1;
	        }
	        if ( b == base ) {
	            b = 0;
	            a += 1;
	            if ( a == base ) {
	                a = 1;
	                minDigits += 1;
	            }
	        }
	        return result;
	    }			
		
		private int minDigits;		
		private int a = 1;
		private int b = 0;
		
		private final int base;
		private final int maxDigits;
		
	}
	
	private static String convertToBase(int base, long number) {
		if ( base < 2 || base > 10 ) {
			throw new AssertionError("Base should be in the range: 2 << base << 10");
		}
		
		if ( number == 0 ) {
			return "0";
		}
	
	    StringBuilder result = new StringBuilder();
	    while ( number != 0 ) {
	        result.append(number % base);
	        number /= base;
	    }
	
	    return result.reverse().toString();
	}

	
	private static boolean isPrime(long number) {
	    if ( number < 2 ) {
	        return false;
	    }
	    if ( number % 2 == 0 ) {
	        return number == 2;
	    }
	    if ( number % 3 == 0 ) {
	        return number == 3;
	    }
	
	    for ( long p = 5; p * p <= number; p += 4 ) {
	        if ( number % p == 0 ) {
	            return false;
	        }
	        p += 2;
	        if ( number % p == 0 ) {
	            return false;
	        }
	    }
	
	    return true;
	}

}
