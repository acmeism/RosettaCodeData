import module java.base;

public final class ShuffleGroups {

	public static void main() {
		int maxFactor = NUMBER_BASE - 1;
		DigitsOfNumber[] test = new DigitsOfNumber[maxFactor];
		List<Witness> solutions = new ArrayList<Witness>();
		
		// Initialise the 'test' list
		IntStream.range(0, maxFactor).forEach( factor -> {
			test[factor] = new DigitsOfNumber();
			resetDigits(test[factor], 0);
		} );	
	
		while ( test[0].witnesses.size() != 4 ) {
	        // Increment all numbers
	    	IntStream.rangeClosed(1, maxFactor).forEach( i -> incrementDigits(test[i - 1], i) );	
	
	        // Skip numbers ending with zero
	    	if ( test[0].digits[0] == 0 ) {
	            continue;
	        }	
	
	        // Recalculate if necessary
	    	if ( test[0].digits[test[0].countDecimalDigitsInNumber - 1] == NUMBER_BASE / 2 ) {
	        	final long i = test[0].number * 2 - 1;
	    		IntStream.range(1, NUMBER_BASE).forEach( factor -> resetDigits(test[factor - 1], factor * i) );            	
	            maxFactor = NUMBER_BASE - 1;
	        }
	
	        // Check if multiples of 'test.get(0)' share the same digits
	        for ( int factor = 2; factor <= maxFactor; factor++ ) {
	            if ( test[0].countDecimalDigitsInNumber != test[factor - 1].countDecimalDigitsInNumber ) {
	                maxFactor -= 1;
	            }
	
	            if ( Arrays.equals(test[0].countsOfDigits, test[factor - 1].countsOfDigits) ) {
	            	test[0].witnesses.add(factor);
	            }
	        }
	
	        if ( ! test[0].witnesses.isEmpty() ) {
                solutions.add( new Witness(test[0].number, new TreeSet<Integer>(test[0].witnesses) ) );
	        }
	    }

	    IO.println("Solutions found: %d".formatted(solutions.size()));
	    printFirstNSolutions(solutions, 20);
	    printFirstSolutionGreaterThan4Witnesses(solutions);
	    int factor = firstSolutionWithExactlyNWitnesses(solutions, 3);
	    printFirstNWitnessCounts(solutions, factor);
	    factor = firstSolutionWithExactlyNWitnesses(solutions, 4);
	    printFirstNWitnessCounts(solutions, factor);
	}
	
	// Increment the digits of 'digitsOfNumber' by the 'carry' value
	private static void incrementDigits(DigitsOfNumber digitsOfNumber, int carry) {
		digitsOfNumber.number += carry;
		int index = 0;
		
		while ( carry > 0 && index < digitsOfNumber.countDecimalDigitsInNumber ) {
			int digit = digitsOfNumber.digits[index];
			digitsOfNumber.countsOfDigits[digit] -= 1;
		
		    digit += carry;
		    carry = ( digit >= NUMBER_BASE ) ? 1 : 0;
		    digit = ( digit >= NUMBER_BASE ) ? digit - NUMBER_BASE : digit;
		
		    digitsOfNumber.digits[index] = digit;
		    digitsOfNumber.countsOfDigits[digit] += 1;
		    index += 1;
		}
		
		if ( carry != 0 ) {
			digitsOfNumber.digits[index] = carry;
			digitsOfNumber.countsOfDigits[carry] += 1;
		    digitsOfNumber.countDecimalDigitsInNumber += 1;
		}
		
		digitsOfNumber.witnesses.clear();
	}
	
	// Reset the 'digitsOfNumber' class for computation with the integer 'n'
	private static void resetDigits(DigitsOfNumber digitsOfNumber, long n) {
	    digitsOfNumber.number = n;
	    Arrays.fill(digitsOfNumber.digits, 0);
	    Arrays.fill(digitsOfNumber.countsOfDigits, 0);
	    digitsOfNumber.witnesses.clear();
	
	    int count = 0;
	    while ( n > 0 ) {
	    	final int digit = Math.floorMod(n, NUMBER_BASE);
	    	n /= NUMBER_BASE;
	    	digitsOfNumber.digits[count] = digit;
	    	digitsOfNumber.countsOfDigits[digit] += 1;
	        count += 1;
	    }
	
	    digitsOfNumber.countDecimalDigitsInNumber = count;
	}
	
	// Print the number of occurrences of witness counts within a 'limit'
	private static void printFirstNWitnessCounts(List<Witness> solutions, int limit) {
	    IO.println("For the first %d shuffle groups, there are:".formatted(limit + 1));
	    Map<Integer, Integer> counts = new TreeMap<Integer, Integer>();

	    IntStream.rangeClosed(0, limit).forEach( i ->
	    	counts.merge(solutions.get(i).witnesses.size() + 1, 1, Integer::sum) );

	    IO.println("  factor count      witnesses");
	    counts.keySet().stream().forEach( i -> IO.println("%9d%16d".formatted(i - 1, counts.get(i))) );
	    IO.println();
	}
	
	// Print the first solution with exactly 'n' witnesses
	private static int firstSolutionWithExactlyNWitnesses(List<Witness> solutions, int n) {
	    IO.println("First shuffle group with exactly %d witnesses:".formatted(n));
	    IO.println("  index  count        number   factor");
	
	    Optional<Integer> index = IntStream.range(0, solutions.size())
	    	.filter( i -> solutions.get(i).witnesses.size() == n ).boxed().findFirst();
	    		
	    if ( index.isPresent() ) {
	    	final int idx = index.get();
	        printWitness(solutions.get(idx), idx + 1);
	        IO.println();
	        return idx;
	    } else {
	        IO.println("Not found within limit: %d".formatted(solutions.size()));
	        IO.println();
	        return 0;
	    }
	}
	
	// Print the first solution with more than 4 witnesses
	private static void printFirstSolutionGreaterThan4Witnesses(List<Witness> solutions) {
	    IO.println("First solution with more than 4 witnesses:");
	    IO.println("  index  count        number   factor");
	
	    Optional<Integer> index = IntStream.range(0, solutions.size())
		    .filter( i -> solutions.get(i).witnesses.size() > 4 ).boxed().findFirst();
	
	    if ( index.isPresent() ) {
	    	final int idx = index.get();
	        printWitness(solutions.get(idx), idx + 1);
	    } else {
	        IO.println("Not found. Only %d solutions".formatted(solutions.size()));
	    }
	    IO.println();	
	}
	
	// Print the first 'count' solutions
	private static void printFirstNSolutions(List<Witness> solutions, int count) {
	    final int requiredCount = Math.min(count, solutions.size());
	    IO.println("\nFirst %d shuffle groups:".formatted(requiredCount));
	    IO.println("  index  count        number   factor");
	    IntStream.range(0, requiredCount).forEach( i -> printWitness(solutions.get(i), i + 1) );
	    IO.println();
	}
	
	// Print a formatted Witness record
	private static void printWitness(Witness witness, int index) {
	    IO.print("%7d".formatted(index));
	    IO.print("%7d".formatted(witness.witnesses.size()));
	    IO.print("%14d".formatted(witness.number));
	    witness.witnesses.forEach( i -> IO.print("   |x%d%11d".formatted(i, i * witness.number)) );
	    IO.println();
	}
	
	private static final class DigitsOfNumber {
		
		private long number;
		private int[] digits = new int[MAX_DIGITS_IN_JAVA_LONG];
		private int[] countsOfDigits = new int[NUMBER_BASE];
		private Set<Integer> witnesses = new TreeSet<Integer>();
		private int countDecimalDigitsInNumber;
		
	}
	
	private record Witness(long number, Set<Integer> witnesses) {}
	
	private static final int NUMBER_BASE = 10;
    private static final int MAX_DIGITS_IN_JAVA_LONG = 19;

}
