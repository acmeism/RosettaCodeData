import std.stdio, std.typecons, std.algorithm, std.traits, std.array,
       std.range, std.random;

enum Pip {Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten,
          Jack, Queen, King, Ace}
enum Suit {Diamonds, Spades, Hearts, Clubs}
alias Card = Tuple!(Pip, Suit);

auto newDeck() pure nothrow @safe {
    return cartesianProduct([EnumMembers!Pip], [EnumMembers!Suit]);
}

alias shuffleDeck = randomShuffle;

Card dealCard(ref Card[] deck) pure nothrow @safe @nogc {
    immutable card = deck.back;
    deck.popBack;
    return card;
}

void show(in Card[] deck) @safe {
    writefln("Deck:\n%(%s\n%)\n", deck);
}

void main() /*@safe*/ {
    auto d = newDeck.array;
    d.show;
    d.shuffleDeck;
    while (!d.empty)
        d.dealCard.writeln;
}
