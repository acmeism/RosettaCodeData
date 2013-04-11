bool isKaprekar(in uint n) pure nothrow {
    ulong powr = n ^^ 2UL;
    ulong r, l, tens = 10;
    while (r < n) {
        r = powr % tens;
        l = powr / tens;
        if (r && (l + r == n))
            return true;
        tens *= 10;
    }
    return false;
}

void main() {
    import std.stdio;
    int count = 1;
    foreach (i; 1 .. 1_000_000)
        if (isKaprekar(i))
            writefln("%d: %d", count++, i);
}
