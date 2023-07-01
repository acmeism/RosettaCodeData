import std.stdio, std.typecons;

__gshared uint[32] best;

uint topswops(size_t n)() nothrow @nogc {
    static assert(n > 0 && n < best.length);
    size_t d = 0;

    alias T = byte;
    alias Deck = T[n];

    void trySwaps(in ref Deck deck, in uint f) nothrow @nogc {
        if (d > best[n])
            best[n] = d;

        foreach_reverse (immutable i; staticIota!(0, n)) {
            if ((deck[i] == i || (deck[i] == -1 && !(f & (1U << i))))
                && (d + best[i] >= best[n] || deck[i] == -1))
            break;
            if (d + best[i] <= best[n])
                return;
        }

        Deck deck2 = void;
        foreach (immutable i; staticIota!(0, n)) // Copy.
            deck2[i] = deck[i];

        d++;
        foreach (immutable i; staticIota!(1, n)) {
            enum uint k = 1U << i;
            if (deck[i] != i && (deck[i] != -1 || (f & k)))
                continue;

            deck2[0] = T(i);
            foreach_reverse (immutable j; staticIota!(0, i))
                deck2[i - j] = deck[j]; // Reverse copy.
            trySwaps(deck2, f | k);
        }
        d--;
    }

    best[n] = 0;
    Deck deck0 = -1;
    deck0[0] = 0;
    trySwaps(deck0, 1);
    return best[n];
}

void main() {
    foreach (immutable i; staticIota!(1, 14))
        writefln("%2d: %d", i, topswops!i());
}
