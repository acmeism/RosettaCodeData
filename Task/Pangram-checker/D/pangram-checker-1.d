bool isPangram(in string text) pure nothrow {
    uint bitset;

    foreach (c; text) {
        if (c >= 'a' && c <= 'z')
            bitset |= (1u << (c - 'a'));
        else if (c >= 'A' && c <= 'Z')
            bitset |= (1u << (c - 'A'));
    }

    return bitset == 0b11_11111111_11111111_11111111;
}

void main() {
    assert(isPangram("the quick brown fox jumps over the lazy dog"));
    assert(!isPangram("ABCDEFGHIJKLMNOPQSTUVWXYZ"));
    assert(!isPangram("ABCDEFGHIJKL.NOPQRSTUVWXYZ"));
    assert(isPangram("ABC.D.E.FGHI*J/KL-M+NO*PQ R\nSTUVWXYZ"));
}
