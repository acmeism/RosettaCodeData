import groovy.transform.TupleConstructor

enum Pip {
    ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING
}
enum Suit {
    DIAMONDS, SPADES, HEARTS, CLUBS
}

@TupleConstructor
class Card {
    final Pip pip
    final Suit suit

    String toString() { "$pip of $suit" }
}

class Deck {
    private LinkedList cards = []

    Deck() { reset() }

    void reset() {
        cards = []
        Suit.values().each { suit ->
            Pip.values().each { pip ->
                cards << new Card(pip, suit)
            }
        }
    }

    Card deal() { cards.poll() }

    void shuffle() { Collections.shuffle cards }

    String toString() { cards.isEmpty() ? "Empty Deck" : "Deck $cards" }
}
