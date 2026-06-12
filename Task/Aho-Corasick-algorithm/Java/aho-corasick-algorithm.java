import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class AhoCorasickAlgorithm {
	
	public static void main(String[] args) {
		String text = "abaaabaa";
		List<String> targets = List.of( "a", "bb", "aa", "abaa", "abaaa" );
		
		maxStateCount = targets.stream().mapToInt( s -> Integer.valueOf(s.length()) ).sum();
	
		buildMatchingMachine(targets);
	    searchForTargets(text, targets);
	} 	
	
	// Build a pattern matching machine and return the number of states created
	private static int buildMatchingMachine(List<String> targets) { 	
	    // Initialisation
		failures = new ArrayList<Integer>(Collections.nCopies(maxStateCount, 0));	
		results = new ArrayList<Integer>(Collections.nCopies(maxStateCount, 0));	
	    trie = IntStream.range(0, maxStateCount)
	    				.mapToObj( i -> new ArrayList<Integer>(Collections.nCopies(ALPHABET_SIZE, 0)) )
	    				.collect(Collectors.toList());	
	
	    int nextStateID = 1; // Initially there is only the empty state
	
	    // Build the trie
	    for ( int i = 0; i < targets.size(); i++ ) {
	        String target = targets.get(i);
	        validateLowerCaseLetters(target);
	        int currentState = 0;
	
	        // Process all characters of the current target
	        for ( char ch : target.toCharArray() ) {
	        	final int charCode = ch - 'a';
	
	            // Allocate a new state for 'charCode', if one does not already exist
	            if ( trie.get(currentState).get(charCode) == 0) {
	                trie.get(currentState).set(charCode, nextStateID++);
	            }
	
	            currentState = trie.get(currentState).get(charCode);
	        }
	
	        // Bit-map the index of the 'target' word in 'targets' to the 'results' list,
	        // indicating that it ends in the 'currentState'
	        results.set(currentState, results.get(currentState) | ( 1 << i ));
	    }
	
	    // Determine 'failures' values using a breadth first search
	    Queue<Integer> queue = new ArrayDeque<Integer>();
	
	    // If an alphabetic character has a positive state, its failure value is zero
	    IntStream.range(0, ALPHABET_SIZE).forEach( ch -> {
	        if ( trie.getFirst().get(ch) > 0 ) {
	            failures.set(trie.getFirst().get(ch), 0);
	            queue.offer(trie.getFirst().get(ch));
	        }
	    } );
	
	    while ( ! queue.isEmpty() ) { 	
	        final int state = queue.poll();
	
	        // Determine the 'failures' value for all alphabetic characters with an undefined state
	        IntStream.range(0, ALPHABET_SIZE).forEach( ch -> {
	            if ( trie.get(state).get(ch) != 0 ) {
	                int failure = failures.get(state);
	
	                while ( trie.get(failure).get(ch) == 0 ) {
	                     failure = failures.get(failure);
	                }
	
	                failure = trie.get(failure).get(ch);
	                failures.set(trie.get(state).get(ch), failure);
	
	                // Merge 'results' values
	                results.set(trie.get(state).get(ch), results.get(trie.get(state).get(ch)) | results.get(failure));
	
	                // Insert the next level state into the queue
	                queue.offer(trie.get(state).get(ch));
	            }
	        } );
	    }
	    return nextStateID; // 'nextStateID' is also the total number of states created
	}
	
	// Display all occurrences of the target words in the given text
	private static void searchForTargets(String text, List<String> targets) {
		validateLowerCaseLetters(text);
		
		// Initialisation
        Map<String, List<Integer>> printableResults = targets.stream().collect(Collectors.toMap(
        	Function.identity(), v -> new ArrayList<Integer>(), (previous, next) -> next, LinkedHashMap::new));	
        	
	    int currentState = 0;
	
	    // Process the characters of 'text' through the matching machine
	    for ( int i = 0; i < text.length(); i++ ) { 	
	        currentState = findNextState(currentState, text.charAt(i));
	
	        // If a match is not found, move to next character of 'text'
	        if ( results.get(currentState) == 0 ) {
	             continue;
	        }
	
	        // A match has been found, so store the start index of the target word in the 'printableResults' map
	        for ( int j = 0; j < targets.size(); j++ ) {
	            if ( ( results.get(currentState) & ( 1 << j ) ) > 0 ) {	
	            	printableResults.get(targets.get(j)).addLast(i + 1 - targets.get(j).length());
	            }
	        } 	
	    }
	
        // Print the results of the search
	    for ( Map.Entry<String, List<Integer>> entry : printableResults.entrySet() ) {
	    	System.out.println("The word \"" + entry.getKey() + "\" appears in \"" + text
	    			           + "\" starting at indexes " + entry.getValue());
	    }
	} 	

	// Return the next state to which the matching machine will transition
	private static int findNextState(int currentState, char nextCharacter) {
	    final int ch = nextCharacter - 'a';
	
	    // Follow the links to the first state not undefined
	    while ( trie.get(currentState).get(ch) == 0 ) {
	        currentState = failures.get(currentState);
	    }
	
	    return trie.get(currentState).get(ch);
	}
	
	// Throw an exception if the given 'word' contains a character which is not a lower case alphabetic letter
	private static void validateLowerCaseLetters(String word) {
		for ( char ch : word.toCharArray() ) {
			if ( ch < 'a' || ch > 'z' ) {
	            throw new IllegalArgumentException("Invalid character in pattern: " + ch);
	        }
		}
	}
	
	private static int maxStateCount; // The maximum number of states required to process the 'targets' words
	// 'results' stores the indexes of all the 'target' words in 'targets' that end in the current state.
	// Multiple indexes are stored in a single value by bit-mapping each index, that is, multiplying by a power of two.
	private static List<Integer> results;
	// 'failures' stores the index of the failure link state in the trie for each index of a 'target' word in 'targets'
	private static List<Integer> failures;
	private static List<List<Integer>> trie; // The trie containing the characters of the 'target' words	
	
	private static final int ALPHABET_SIZE = 26;	

}
