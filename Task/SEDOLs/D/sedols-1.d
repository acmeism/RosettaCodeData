import std.stdio, std.algorithm, std.string, std.numeric, std.ascii;

char checksum(in char[] sedol)
in {
    assert(sedol.length == 6);
    foreach (c; sedol)
        assert(isDigit(c) || (isUpper(c) && !canFind("AEIOU", c)));
} out (result) {
    assert(isDigit(result));
} body {
    static int c2v(in dchar c){ return isDigit(c) ? c-'0' : c-'A'+10; }
    immutable int d = sedol.map!c2v().dotProduct([1,3,1,7,3,9]);
    return '0' + 10 - (d % 10);
}

void main() {
    foreach (sedol; "710889 B0YBKJ 406566 B0YBLH 228276
                     B0YBKL 557910 B0YBKR 585284 B0YBKT".split())
        writeln(sedol, checksum(sedol));
}
