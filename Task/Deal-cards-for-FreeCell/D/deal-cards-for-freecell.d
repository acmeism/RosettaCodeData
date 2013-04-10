import std.stdio, std.conv, std.algorithm, std.range;

struct RandomGenerator {
    uint seed = 1;

    @property uint next() pure nothrow {
        seed = (seed * 214_013 + 2_531_011) & int.max;
        return seed >> 16;
    }
}

struct Deck {
    int[52] cards;

    void deal(in uint seed) /*pure nothrow*/ {
        enum int nc = cards.length; // Must be signed for iota.

        copy(iota(nc - 1, -1, -1), cards[]); // not pure nothrow

        auto rnd = RandomGenerator(seed);
        foreach (i, ref c; cards)
            swap(c, cards[(nc - 1) - rnd.next % (nc - i)]);
    }

    void show() {
        foreach (row; std.range.chunks(cards[], 8)) {
            foreach (c; row)
                write(" ", "A23456789TJQK"[c / 4], "CDHS"[c % 4]);
            writeln();
        }
    }
}

void main(in string[] args) {
    immutable seed = (args.length == 2) ? to!uint(args[1]) : 11_982;
    writeln("Hand ", seed);
    Deck cards;
    cards.deal(seed);
    cards.show();
}
