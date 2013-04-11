import std.string, std.traits, std.uni;

// Do not compile with -g (debug info).
enum Alphabet : dstring {
    DE = "abcdefghijklmnopqrstuvwxyzßäöü",
    EN = "abcdefghijklmnopqrstuvwxyz",
    SV = "abcdefghijklmnopqrstuvwxyzåäö"
}

bool isPangram(S)(in S s, dstring alpha = Alphabet.EN)
pure /*nothrow*/ if (isSomeString!S) {
    foreach (dchar c; alpha)
       if (indexOf(s, c) == -1 && indexOf(s, std.uni.toUpper(c)) == -1)
            return false;
    return true;
}

void main() {
    assert(isPangram("the quick brown fox jumps over the lazy dog".dup, Alphabet.EN));
    assert(isPangram("Falsches Üben von Xylophonmusik quält jeden größeren Zwerg"d, Alphabet.DE));
    assert(isPangram("Yxskaftbud, ge vår wczonmö iqhjälp"w, Alphabet.SV));
}
