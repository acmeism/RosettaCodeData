import java.util.List;

public final class LyndonWord {

	public static void main(String[] args) {
		List<String> alphabet = List.of( "0", "1" );
		String word = alphabet.getFirst();
		while ( ! word.isEmpty() ) {		
			System.out.println(word);
			word = nextWord(5, word, alphabet);
		}
	}

	// Using the Duval (1988) algorithm
	private static String nextWord(int maxLength, String word, List<String> alphabet) {
		// Step 1: Repeat the word and truncate
	    String nextWord = word;
	    while ( nextWord.length() < maxLength ) {
	    	nextWord += word;
	    }
	    nextWord = nextWord.substring(0, maxLength);
	
	    // Step 2: Remove last symbol of the next word if it is the last symbol in the alphabet
	    final String alphabetLastSymbol = alphabet.getLast();
	    while ( nextWord.endsWith(alphabetLastSymbol) ) {
	    	nextWord = nextWord.substring(0, nextWord.length() - 1);
	    }
	
	    // Step 3: Replace the last symbol of the next word by its successor in the alphabet
	    if ( ! nextWord.isEmpty() ) {
		    final String wordLastSymbol = nextWord.substring(nextWord.length() - 1);
		    final int index = alphabet.indexOf(wordLastSymbol) + 1;
		    nextWord = nextWord.substring(0, nextWord.length() - 1);
		    nextWord += alphabet.get(index);
	    }
	    return nextWord;
	}

}
