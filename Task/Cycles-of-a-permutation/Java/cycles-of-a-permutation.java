import java.util.ArrayList;
import java.util.Collections;
import java.util.EnumSet;
import java.util.HashSet;
import java.util.List;
import java.util.NavigableSet;
import java.util.Objects;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class CyclesOfAPermutation {

	public static void main(String[] args) {
		enum Day {
			
			MONDAY("HANDYCOILSERUPT"), TUESDAY("SPOILUNDERYACHT"), WEDNESDAY("DRAINSTYLEPOUCH"),
			THURSDAY("DITCHSYRUPALONE"), FRIDAY("SOAPYTHIRDUNCLE"), SATURDAY("SHINEPARTYCLOUD"),
			SUNDAY("RADIOLUNCHTYPES");
			
			public Day previous() {
		        return Objects.requireNonNullElseGet(days.lower(this), days::last);
		    }
			
			public String letters() {
				return letters;
			}
			
			private Day(String aLetters) {
				letters = aLetters;
			}
			
			private String letters;

			private static NavigableSet<Day> days = new TreeSet<Day>(EnumSet.allOf(Day.class));
			
		}
		
		Permutation permutation = new Permutation(Day.MONDAY.letters.length());
				
		System.out.println("On Thursdays Alf and Betty should rearrange their letters using these cycles:");
		List<Integer> oneLineWedThu = permutation.createOneLine(Day.WEDNESDAY.letters(), Day.THURSDAY.letters());
		List<List<Integer>> cyclesWedThu = permutation.oneLineToCycles(oneLineWedThu);
		System.out.println(cyclesWedThu);
		System.out.println("So that " + Day.WEDNESDAY.letters() + " becomes " + Day.THURSDAY.letters());
		
		System.out.println("\n" + "Or they could use the one line notation:");
		System.out.println(oneLineWedThu);
		
		System.out.println("\n" + "To revert to the Wednesday arrangement they should use these cycles:");
		List<List<Integer>> cyclesThuWed = permutation.cyclesInverse(cyclesWedThu);
		System.out.println(cyclesThuWed);
		
		System.out.println("\n" + "Or with the one line notation:");
		List<Integer> oneLineThuWed = permutation.oneLineInverse(oneLineWedThu);
		System.out.println(oneLineThuWed);
		System.out.println("So that " + Day.THURSDAY.letters() + " becomes "
							+ permutation.oneLinePermuteString(Day.THURSDAY.letters(), oneLineThuWed));
		
		System.out.println("\n" + "Starting with the Sunday arrangement and applying each of the daily");
		System.out.println("arrangements consecutively, the arrangements will be:");
		System.out.println("\n" + " ".repeat(6) + Day.SUNDAY.letters() + "\n");		
		for ( Day day : Day.values() ) {
		    List<Integer> dayOneLine = permutation.createOneLine(day.previous().letters(), day.letters());
		    String result = permutation.oneLinePermuteString(day.previous().letters(), dayOneLine);
			System.out.println(
				String.format("%11s%s%s", day.name() + ": ", result, ( day == Day.SATURDAY ) ? "\n" : ""));							   		
		}
		
		System.out.println("\n" + "To go from Wednesday to Friday in a single step they should use these cycles:");
		List<Integer> oneLineThuFri = permutation.createOneLine(Day.THURSDAY.letters(), Day.FRIDAY.letters());
		List<List<Integer>> cyclesThuFri = permutation.oneLineToCycles(oneLineThuFri);
		List<List<Integer>> cyclesWedFri = permutation.combinedCycles(cyclesWedThu, cyclesThuFri);
		System.out.println(cyclesWedFri);
		System.out.println("So that " + Day.WEDNESDAY.letters() + " becomes "
							+ permutation.cyclesPermuteString(Day.WEDNESDAY.letters(), cyclesWedFri));
		
		System.out.println("\n" + "These are the signatures of the permutations:" + "\n");
		for ( Day day : Day.values() ) {
			List<Integer> oneLine = permutation.createOneLine(day.previous().letters(), day.letters());
			System.out.println(String.format("%11s", day.name() + ": ") + permutation.signature(oneLine));
		}
		
		System.out.println("\n" + "These are the orders of the permutations:" + "\n");
		for ( Day day : Day.values() ) {
			List<Integer> oneLine = permutation.createOneLine(day.previous().letters(), day.letters());
			System.out.println(String.format("%11s", day.name() + ": ") + permutation.order(oneLine));
		}
		
		System.out.println("\n" + "Applying the Friday cycle to a string 10 times:");
		String word = "STOREDAILYPUNCH";
		System.out.println("\n" + " 0 " + word + "\n");
		for ( int i = 1; i <= 10; i++ ) {
			word = permutation.cyclesPermuteString(word, cyclesThuFri);
		    System.out.println(String.format("%2d%s%s%s", i, " ", word, ( i == 9 ) ? "\n" : ""));
		}
	}	
}

final class Permutation {
	
	// Initialise the length of the strings to be permuted.
	public Permutation(int aLettersCount) {
		lettersCount = aLettersCount;
	}
	
	// Return the permutation in one line form that transforms the string 'source' into the string 'destination'.
    public List<Integer> createOneLine(String source, String destination) {
        List<Integer> result = new ArrayList<Integer>();
        for ( char ch : destination.toCharArray() ) {
        	result.addLast(source.indexOf(ch) + 1);
        }

        while ( result.getLast() == result.size() ) {
        	result.removeLast();
        }

        return result;
    }

    // Return the cycles of the permutation given in one line form.
    public List<List<Integer>> oneLineToCycles(List<Integer> oneLine) {
    	List<List<Integer>> cycles = new ArrayList<List<Integer>>();
    	Set<Integer> used = new HashSet<Integer>();
    	
    	for ( int number = 1; used.size() < oneLine.size(); number++ ) {
    		if ( ! used.contains(number) ) {
 	    		int index = oneLine.indexOf(number) + 1;
 	    		
	    		if ( index > 0 ) {
	    			List<Integer> cycle = new ArrayList<Integer>();
	    			cycle.addLast(number);
	    			
	    			while ( number != index ) {
	    	            cycle.addLast(index);    	
	    	            index = oneLine.indexOf(index) + 1;
	    			}
	    			
	    			if ( cycle.size() > 1 ) {
	    				cycles.addLast(cycle);
	    			}
	    			used.addAll(cycle);
	    		}
    		}    		
    	}    	

    	return cycles;
    }

    // Return the one line notation of the permutation given in cycle form.
    public List<Integer> cyclesToOneLine(List<List<Integer>> cycles) {
    	List<Integer> oneLine = IntStream.rangeClosed(1, lettersCount).boxed().collect(Collectors.toList());
        for	( int number = 1; number <= lettersCount; number++ ) {
        	for ( List<Integer> cycle : cycles ) {
        		final int index = cycle.indexOf(number);
        		if ( index >= 0 ) {
        			oneLine.set(number - 1, cycle.get(( index - 1 + cycle.size() ) % cycle.size()));
        			break;
        		}
        	}
        }

        return oneLine;
    }

    // Return the inverse of the given permutation in cycle form.
    public List<List<Integer>> cyclesInverse(List<List<Integer>> cycles) {
    	List<List<Integer>> cyclesInverse =
    		cycles.stream().map( list -> new ArrayList<Integer>(list) ).collect(Collectors.toList());

        for ( List<Integer> cycle : cyclesInverse ) {
        	cycle.addLast(cycle.removeFirst());
        	Collections.reverse(cycle);
        }

        return cyclesInverse;
    }

    // Return the inverse of the given permutation in one line notation.
    public List<Integer> oneLineInverse(List<Integer> oneLine) {
    	List<Integer> oneLineInverse = Stream.generate( () -> 0 ).limit(oneLine.size()).collect(Collectors.toList());
    	for ( int number = 1; number <= oneLine.size(); number++ ) {
    		oneLineInverse.set(number - 1, oneLine.indexOf(number) + 1);
    	}
    	
    	return oneLineInverse;
    }

    // Return the cycles obtained by composing cycleOne first followed by cycleTwo.
    public List<List<Integer>> combinedCycles(List<List<Integer>> cyclesOne, List<List<Integer>> cyclesTwo) {
    	List<List<Integer>> combinedCycles = new ArrayList<List<Integer>>();
    	Set<Integer> used = new HashSet<Integer>();

    	for ( int number = 1; used.size() < lettersCount; number++ ) {
    		if ( ! used.contains(number) ) {    		
	    		int combined = next(next(number, cyclesOne), cyclesTwo);
	    		List<Integer> cycle = new ArrayList<Integer>();
	    		cycle.addLast(number);
	    		
	    		while ( number != combined ) {
	    			cycle.addLast(combined);
	       			combined = next(next(combined, cyclesOne), cyclesTwo);   			
	    		}
	    		
	    		if ( cycle.size() > 1 ) {
	    			combinedCycles.addLast(cycle);
	    		}
	    		used.addAll(cycle);
    		}
    	}
    	
    	return combinedCycles;
    }

    // Return the given string permuted by the permutation given in one line form.
    public String oneLinePermuteString(String text, List<Integer> oneLine) {    	
    	List<String> permuted = new ArrayList<String>();
    	
    	for ( int index : oneLine ) {
    		permuted.addLast(text.substring(index - 1, index));
    	}     	
    	permuted.addLast(text.substring(permuted.size()));
    	
    	return String.join("", permuted);
    }

    // Return the given string permuted by the permutation given in cycle form.
    public String cyclesPermuteString(String text, List<List<Integer>> cycles) {
    	List<String> permuted = text.chars().mapToObj( i -> String.valueOf((char) i) ).collect(Collectors.toList());
    	
    	for ( List<Integer> cycle : cycles ) {
    		for ( int number : cycle ) {
    			permuted.set(next(number, cycles) - 1, text.substring(number - 1, number));
    		}
    	}    	
    	
    	return String.join("", permuted);
    }

    // Return the signature of the permutation given in one line form.
    public String signature(List<Integer> oneLine) {
    	List<List<Integer>> cycles = oneLineToCycles(oneLine);
    	
    	final long evenCount = cycles.stream().filter( list -> list.size() % 2 == 0 ).count();
    	
        return ( evenCount % 2 == 0 ) ? "+1" : "-1";
    }

    // Return the order of the permutation given in one line form.
    public int order(List<Integer> oneLine) {
    	List<List<Integer>> cycles = oneLineToCycles(oneLine);
        List<Integer> sizes = cycles.stream().map( list -> list.size() ).collect(Collectors.toList());

        return sizes.stream().reduce(1, (one, two) -> one * ( two / gcd(one, two) ) );
    }

    // Return the element to which the given number is mapped by the permutation given in cycle form.
    private int next(int number, List<List<Integer>> cycles) {
    	for ( List<Integer> cycle : cycles ) {
    		if ( cycle.contains(number) ) {
    			return cycle.get(( cycle.indexOf(number) + 1 ) % cycle.size());
    		}
    	}
    	
    	return number;
    }

    // Return the greatest common divisor of the two given numbers.
    private int gcd(int one, int two) {
        return ( two == 0 ) ? one : gcd(two, one % two);
    }

    private final int lettersCount;
	
}
