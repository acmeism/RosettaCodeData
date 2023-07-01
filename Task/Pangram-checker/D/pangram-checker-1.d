bool isPangram(in string text) pure nothrow @safe @nogc {
    uint bitset;

    foreach (immutable c; text) {
        if (c >= 'a' && c <= 'z')
            bitset |= (1u << (c - 'a'));
        else if (c >= 'A' && c <= 'Z')
            bitset |= (1u << (c - 'A'));
    }

    return bitset == 0b11_11111111_11111111_11111111;
}

void main() {
    assert("the quick brown fox jumps over the lazy dog".isPangram);
    assert(!"ABCDEFGHIJKLMNOPQSTUVWXYZ".isPangram);
    assert(!"ABCDEFGHIJKL.NOPQRSTUVWXYZ".isPangram);
    assert("ABC.D.E.FGHI*J/KL-M+NO*PQ R\nSTUVWXYZ".isPangram);
}
