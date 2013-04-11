import std.stdio, std.algorithm, std.string, std.numeric, std.ascii;

char sedolChecksum(in char[] sedol) /*pure*/ nothrow
in {
    assert(sedol.length == 6, "SEDOL must be 6 chars long.");
    enum uint mask = 0b11_1110_1111_1011_1110_1110_1110;

    foreach (c; sedol)
        assert(isDigit(c) ||
               (c > 'A' && c <= 'Z' && ((1U << (c - 'A')) & mask)),
               "SEDOL with wrong char.");
} out(result) {
    assert(isDigit(result));
    static int c2v(in dchar c){ return isDigit(c) ? c-'0' : c-'A'+10; }
    immutable int d = sedol.map!c2v().dotProduct([1,3,1,7,3,9]);
    assert((d + result - '0') % 10 == 0);
} body {
    enum int[] weights = [1, 3, 1, 7, 3, 9];

    int sum = 0;
    foreach (i, c; sedol) {
        if (isDigit(c))
            sum += (c - '0') * weights[i];
        else
            sum += (c - 'A' + 10) * weights[i];
    }

    return '0' + 10 - (sum % 10);
}

void main() {
    foreach (s; ["710889", "B0YBKJ", "406566", "B0YBLH", "228276",
                 "B0YBKL", "557910", "B0YBKR", "585284", "B0YBKT"])
        writeln(s, s.sedolChecksum());
}
