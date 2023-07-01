import std.stdio, std.string, std.algorithm, std.range;

string analyzeHand(in string inHand) pure /*nothrow @safe*/ {
    enum handLen = 5;
    static immutable face = "A23456789TJQK", suit = "SHCD";
    static immutable errorMessage = "invalid hand.";

    /*immutable*/ const hand = inHand.toUpper.split.sort().release;
    if (hand.length != handLen)
        return errorMessage;
    if (hand.uniq.walkLength != handLen)
        return errorMessage ~ " Duplicated cards.";

    ubyte[face.length] faceCount;
    ubyte[suit.length] suitCount;
    foreach (immutable card; hand) {
        if (card.length != 2)
            return errorMessage;
        immutable n = face.countUntil(card[0]);
        immutable l = suit.countUntil(card[1]);
        if (n < 0 || l < 0)
            return errorMessage;
        faceCount[n]++;
        suitCount[l]++;
    }

    return analyzeHandHelper(faceCount, suitCount);
}

private string analyzeHandHelper(const ref ubyte[13] faceCount,
                                 const ref ubyte[4] suitCount)
pure nothrow @safe @nogc {
    bool p1, p2, t, f, fl, st;

    foreach (immutable fc; faceCount)
        switch (fc) {
            case 2: (p1 ? p2 : p1) = true; break;
            case 3: t = true; break;
            case 4: f = true; break;
            default: // Ignore.
        }

    foreach (immutable sc; suitCount)
        if (sc == 5) {
            fl = true;
            break;
        }

    if (!p1 && !p2 && !t && !f) {
        uint s = 0;
        foreach (immutable fc; faceCount) {
            if (fc)
                s++;
            else
                s = 0;
            if (s == 5)
                break;
        }

        st = (s == 5) || (s == 4 && faceCount[0] && !faceCount[1]);
    }

    if (st && fl)      return "straight-flush";
    else if (f)        return "four-of-a-kind";
    else if (p1 && t)  return "full-house";
    else if (fl)       return "flush";
    else if (st)       return "straight";
    else if (t)        return "three-of-a-kind";
    else if (p1 && p2) return "two-pair";
    else if (p1)       return "one-pair";
    else               return "high-card";
}

void main() {
    // S = Spades, H = Hearts, C = Clubs, D = Diamonds.
    foreach (immutable hand; ["2H 2D 2S KS QD",
                              "2H 5H 7D 8S 9D",
                              "AH 2D 3S 4S 5S",
                              "2H 3H 2D 3S 3D",
                              "2H 7H 2D 3S 3D",
                              "2H 7H 7D 7S 7C",
                              "TH JH QH KH AH",
                              "4H 4C KC 5D TC",
                              "QC TC 7C 6C 4C"])
        writeln(hand, ": ", hand.analyzeHand);
}
