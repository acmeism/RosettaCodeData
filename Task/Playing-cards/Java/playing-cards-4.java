import java.util.Collections;
import java.util.LinkedList;

public class Deck {
    private final LinkedList<Card> deck= new LinkedList<Card>();

    public Deck() {
        for (Suit s : Suit.values())
            for (Pip v : Pip.values())
                deck.add(new Card(s, v));
    }

    public Card deal() {
        return deck.poll();
    }

    public void shuffle() {
        Collections.shuffle(deck); // I'm such a cheater
    }

    public String toString(){
        return deck.toString();
    }
}
