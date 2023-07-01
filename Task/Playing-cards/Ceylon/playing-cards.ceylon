import com.vasileff.ceylon.random.api { ... }

"""Run the example code for Rosetta Code ["Playing cards" task] (http://rosettacode.org/wiki/Playing_cards)."""
shared void run() {
    variable value deck = Deck();
    print("New deck (``deck.size`` cards): ``deck``
           ");

    deck = deck.shuffle();
    print("Shuffeled deck (``deck.size`` cards): ``deck``
           ");

    print("Deal three hands: ");
    for (i in 1..3) {
        value [hand, _deck] = deck.deal();
        print("- Dealt ``hand.size`` cards to hand ``i`` : ``join(hand)``");
        deck = _deck;
    }

    print("
           Deck (``deck.size`` cards) after dealing three hands: ``deck``");

}

abstract class Suit() of clubs | hearts | spades | diamonds {}

object clubs    extends Suit() { string = "♣"; }
object hearts   extends Suit() { string = "♥"; }
object spades   extends Suit() { string = "♠"; }
object diamonds extends Suit() { string = "♦"; }

abstract class Pip() of two | three | four | five | six | seven | eight | nine | ten | jack | queen | king | ace {}
object two   extends Pip() { string =  "2"; }
object three extends Pip() { string =  "3"; }
object four  extends Pip() { string =  "4"; }
object five  extends Pip() { string =  "5"; }
object six   extends Pip() { string =  "6"; }
object seven extends Pip() { string =  "7"; }
object eight extends Pip() { string =  "8"; }
object nine  extends Pip() { string =  "9"; }
object ten   extends Pip() { string = "10"; }
object jack  extends Pip() { string =  "J"; }
object queen extends Pip() { string =  "Q"; }
object king  extends Pip() { string =  "K"; }
object ace   extends Pip() { string =  "A"; }

class Card(shared Pip pip, shared Suit suit) {
    string = "``pip`` of ``suit``";
}


String join(Card[] cards) => ", ".join { *cards };

class Deck (cards = [ for (suit in `Suit`.caseValues) for (pip in `Pip`.caseValues) Card(pip, suit) ]) {
    shared Card[] cards;

    shared Deck shuffle(Random rnd = platformRandom())
            => if (nonempty cards)
               then Deck( [*randomize(cards, rnd)] )
               else this;

    shared Integer size => cards.size;

    shared Boolean empty => cards.empty;

    string => if (size > 13)
              then "\n  " + "\n  ". join { *cards.partition(13).map((cards) => join(cards)) }
              else join(cards);

    shared [Card[], Deck] deal(Integer handSize = 5) {
        if (handSize >= cards.size) {
            return [cards, Deck([])];
        }
        else {
            return [
                cards.initial(handSize),
                Deck(cards.skip(handSize).sequence())
            ];
        }
    }
}
