import std.stdio, std.random, std.string, std.array;

struct Card {
    enum suits = ["Clubs", "Hearts", "Spades", "Diamonds"];
    enum pips = ["2", "3", "4", "5", "6", "7", "8", "9", "10",
                 "Jack", "Queen", "King", "Ace"];
    string pip, suit;

    string toString() {
        return pip ~ " of " ~ suit;
    }
}

class Deck {
    Card[] deck;

    this() {
        foreach (suit; Card.suits)
            foreach (pip; Card.pips)
                deck ~= Card(pip, suit);
    }

    void shuffle() {
        deck.randomShuffle();
    }

    Card deal() {
        auto card = deck.back;
        deck.popBack();
        return card;
    }

    override string toString() {
        return format("%(%s\n%)", deck);
    }
}

void main() {
    auto deck = new Deck; // Make A new deck.
    deck.shuffle(); // Shuffle the deck.
    writeln("Card: ", deck.deal()); // Deal from the deck.
    writeln(deck); // Print the current contents of the deck.
}
