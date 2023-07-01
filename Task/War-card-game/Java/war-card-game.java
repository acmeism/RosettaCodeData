import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public final class WarCardGame {

	public static void main(String[] args) {
		WarGame warGame = new WarGame();
		
		while ( ! warGame.gameOver() ) {
			warGame.nextTurn();
		}
		
		warGame.declareWinner();
	}	
	
}

final class WarGame {
	
	public WarGame() {
		deck = new ArrayList<Card>(52);	
        for ( Character suit : SUITS ) {
            for ( Character pip : PIPS ) {
                deck.add( new Card(suit, pip) );
            }
        }
        Collections.shuffle(deck);

        handA = new ArrayList<Card>(deck.subList(0, 26));
        handB = new ArrayList<Card>(deck.subList(26, 52));
        tabledCards = new ArrayList<Card>();
	}
	
	public void nextTurn() {
		Card cardA = handA.remove(0);
		Card cardB = handB.remove(0);
		tabledCards.add(cardA);
		tabledCards.add(cardB);
		int rankA = PIPS.indexOf(cardA.pip);
		int rankB = PIPS.indexOf(cardB.pip);
		
		System.out.print(cardA + "  " + cardB);
		if ( rankA > rankB ) {
            System.out.println("  Player A takes the cards");
            Collections.shuffle(tabledCards);
            handA.addAll(tabledCards);
            tabledCards.clear();
		} else if ( rankA < rankB ) {
            System.out.println("  Player B takes the cards");
            Collections.shuffle(tabledCards);
            handB.addAll(tabledCards);
            tabledCards.clear();
		} else {
	        System.out.println("      War!");
            if ( gameOver() ) {
                return;
            }

            Card cardAA = handA.remove(0);
            Card cardBB = handB.remove(0);
            tabledCards.add(cardAA);
    		tabledCards.add(cardBB);
    		System.out.println("?   ?   Cards are face down");    		
    		if ( gameOver() ) {
                return;
            }
    		
            nextTurn();
		}
	}
	
	public boolean gameOver() {
		return handA.size() == 0 || handB.size() == 0;
	}

    public void declareWinner() {    	
        if ( handA.size() == 0 && handB.size() == 0 ) {
        	System.out.println("The game ended in a tie");
        } else if ( handA.size() == 0 ) {
        	System.out.println("Player B has won the game");
        } else {
            System.out.println("Player A has won the game");
        }
    }

    private record Card(Character suit, Character pip) {
    	
    	@Override
    	public String toString() {
    		return "" + pip + suit;
    	}
    	
    }
	
	private List<Card> deck, handA, handB, tabledCards;
	
	private static final List<Character> PIPS =
		Arrays.asList( '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A' );
	private static final List<Character> SUITS = List.of( 'C', 'D', 'H', 'S' );
	
}
