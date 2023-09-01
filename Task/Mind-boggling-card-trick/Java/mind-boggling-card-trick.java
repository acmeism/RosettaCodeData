import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class MindBogglingCardTrick {

	public static void main(String[] aArgs) {		
		List<Character> cards = new ArrayList<Character>(52);
		cards.addAll(Collections.nCopies(26, 'R'));
		cards.addAll(Collections.nCopies(26, 'B'));
		Collections.shuffle(cards);
		
		List<Character> redPile = new ArrayList<Character>();
		List<Character> blackPile = new ArrayList<Character>();
		List<Character> discardPile = new ArrayList<Character>();	
	
		for ( int i = 0; i < 52; i += 2 ) {
			if ( cards.get(i) == 'R' ) {
				redPile.add(cards.get(i + 1));
			} else {
				blackPile.add(cards.get(i + 1));
			}	
	        discardPile.add(cards.get(i));
	    }
		
		System.out.println("A sample run." + System.lineSeparator());
		System.out.println("After dealing the cards the state of the piles is:");
		System.out.println(String.format("    Red    : %2d cards -> %s", redPile.size(), redPile));
		System.out.println(String.format("    Black  : %2d cards -> %s", blackPile.size(), blackPile));
		System.out.println(String.format("    Discard: %2d cards -> %s", discardPile.size(), discardPile));
		
		ThreadLocalRandom random = ThreadLocalRandom.current();
	    final int minimumSize = Math.min(redPile.size(), blackPile.size());
	    final int choice = random.nextInt(1, minimumSize + 1);
	
	    List<Integer> redIndexes = IntStream.range(0, redPile.size()).boxed().collect(Collectors.toList());
	    List<Integer> blackIndexes = IntStream.range(0, blackPile.size()).boxed().collect(Collectors.toList());
	    Collections.shuffle(redIndexes);
	    Collections.shuffle(blackIndexes);
	    List<Integer> redChosenIndexes = redIndexes.subList(0, choice);
	    List<Integer> blackChosenIndexes = blackIndexes.subList(0, choice);

	    System.out.println(System.lineSeparator() + "Number of cards are to be swapped: " + choice);
	    System.out.println("The respective zero-based indices of the cards to be swapped are:");
	    System.out.println("    Red  : " + redChosenIndexes);
	    System.out.println("    Black: " + blackChosenIndexes);
		
	    for ( int i = 0; i < choice; i++ ) {
	        final char temp = redPile.get(redChosenIndexes.get(i));
	        redPile.set(redChosenIndexes.get(i), blackPile.get(blackChosenIndexes.get(i)));
	        blackPile.set(blackChosenIndexes.get(i), temp);
	    }
	
	    System.out.println(System.lineSeparator() + "After swapping cards the state of the red and black piles is:");
	    System.out.println("    Red  : " + redPile);
	    System.out.println("    Black: " + blackPile);
	
	    int redCount = 0;
	    for ( char ch : redPile ) {
	    	if ( ch == 'R' ) {
	    		redCount += 1;
	    	}
	    }
	
	    int blackCount = 0;
	    for ( char ch : blackPile ) {
	    	if ( ch == 'B' ) {
	    		blackCount += 1;
	    	}
	    }
	
	    System.out.println(System.lineSeparator() + "The number of red cards in the red pile: " + redCount);
	    System.out.println("The number of black cards in the black pile: " + blackCount);
	    if ( redCount == blackCount ) {
	    	System.out.println("So the assertion is correct.");
	    } else {
	    	System.out.println("So the assertion is incorrect.");
	    }		
	}

}
