import std.stdio, std.string, std.conv, std.range, std.algorithm,
       std.ascii, std.typecons;

Nullable!(size_t, 0) repString1(in string s) pure nothrow @safe @nogc
in {
    //assert(s.all!isASCII);
    assert(s.representation.all!isASCII);
} body {
    immutable sr = s.representation;
    foreach_reverse (immutable n; 1 .. sr.length / 2 + 1)
        if (sr.take(n).cycle.take(sr.length).equal(sr))
            return typeof(return)(n);
    return typeof(return)();
}

Nullable!(size_t, 0) repString2(in string s) pure @safe /*@nogc*/
in {
    assert(s.countchars("01") == s.length);
} body {
    immutable bits = s.to!ulong(2);

    foreach_reverse (immutable left; 1 .. s.length / 2 + 1) {
        immutable right = s.length - left;
        if ((bits ^ (bits >> left)) == ((bits >> right) << right))
            return typeof(return)(left);
    }
    return typeof(return)();
}

void main() {
    immutable words = "1001110011 1110111011 0010010010 1010101010
                       1111111111 0100101101 0100100 101 11 00 1".split;

    foreach (immutable w; words) {
        immutable r1 = w.repString1;
        //assert(r1 == w.repString2);
        immutable r2 = w.repString2;
        assert((r1.isNull && r2.isNull) || r1 == r2);
        if (r1.isNull)
            writeln(w, " (no repeat)");
        else
            writefln("%(%s %)", w.chunks(r1));
    }
}
