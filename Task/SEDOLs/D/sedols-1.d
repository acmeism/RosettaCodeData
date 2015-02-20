import std.stdio, std.algorithm, std.string, std.numeric, std.ascii;

char checksum(in char[] sedol) pure @safe /*@nogc*/
in {
    assert(sedol.length == 6);
    foreach (immutable c; sedol)
        assert(c.isDigit || (c.isUpper && !"AEIOU".canFind(c)));
} out (result) {
    assert(result.isDigit);
} body {
    static immutable c2v = (in dchar c) => c.isDigit ? c - '0' : (c - 'A' + 10);
    immutable int d = sedol.map!c2v.dotProduct([1, 3, 1, 7, 3, 9]);
    return digits[10 - (d % 10)];
}

void main() {
    foreach (const sedol; "710889 B0YBKJ 406566 B0YBLH 228276
                          B0YBKL 557910 B0YBKR 585284 B0YBKT".split)
        writeln(sedol, sedol.checksum);
}
