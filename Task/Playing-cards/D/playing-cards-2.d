import std.stdio, std.random, std.algorithm, std.string, std.range;

struct Card {
    static immutable suits = "Club Heart Diamond Spade".split;
    static immutable pips  = "Ace 2 3 4 5 6 7 8 9 10 J Q K".split;
    enum nPack = suits.length * pips.length;

    static bool rankAceTop = true;
    int pip, suit;

    string toString() pure const {
        return format("%3s of %-7s", pips[pip], suits[suit])
               .rightJustify(15);
    }

    @property int order() const nothrow {
        immutable pipOrder = (!rankAceTop) ?
                             pip :
                             (pip ? pip - 1 : 12);
        return pipOrder * suits.length + suit;
    }

    bool opEqual(in Card rhs) const pure nothrow {
        return pip == rhs.pip && suit == rhs.suit;
    }

    int opCmp(in Card rhs) const nothrow {
        return order - rhs.order;
    }
}

final class Deck {
    private Card[] cards;

    this(in bool initShuffle = true, in int pack = 0) {
        cards.length = 0;
        foreach (immutable p; 0 .. pack)
            foreach (immutable c; 0 .. Card.nPack)
                cards ~= Card((c / Card.suits.length) %
                              Card.pips.length,
                              c % Card.suits.length);

        if (initShuffle)
            cards.randomShuffle;
    }

    @property size_t length() const pure nothrow {
        return cards.length;
    }

    Deck add(in Card c) pure nothrow {
        cards ~= c;
        return this;
    }

    Deck deal(in int loc, Deck toDeck = null) pure nothrow {
        if (toDeck !is null)
            toDeck.add(cards[loc]);
        cards = cards[0 .. loc] ~ cards[loc + 1 .. $];
        return this;
    }

    Deck dealTop(Deck toDeck = null) pure nothrow {
        return deal(length - 1, toDeck);
    }

    Card opIndex(in int loc) const pure nothrow {
        return cards[loc];
    }

    alias opIndex peek;

    Deck showDeck() {
        this.writeln;
        return this;
    }

    Deck shuffle() {
        cards.randomShuffle;
        return this;
    }

    Deck sortDeck() {
        cards.sort!q{a > b};
        return this;
    }

    override string toString() pure const {
        return format("%(%(%s%)\n%)", cards.chunks(4));
    }
}

void main() {
    Deck[4] guests;
    foreach (ref g; guests)
        g = new Deck; // Empty deck.

    auto host = new Deck(false, 1);
    writeln("Host");
    host.shuffle.showDeck;

    while (host.length > 0)
        foreach (ref g; guests)
            if (host.length > 0)
                host.dealTop(g);

    foreach (immutable i, g; guests) {
        writefln("Player #%d", i + 1);
        g.sortDeck.showDeck;
    }
}
