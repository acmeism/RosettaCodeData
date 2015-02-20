void main() {
    import std.stdio, std.algorithm, std.string, std.numeric,std.ascii;

    foreach (const s; "710889 B0YBKJ 406566 B0YBLH 228276
                       B0YBKL 557910 B0YBKR 585284 B0YBKT".split)
        writeln(s, '0' + 10 - s
                   .map!(c => c.isDigit ? c - '0' : c - 'A' + 10)
                   .dotProduct([1, 3, 1, 7, 3, 9]) % 10);
}
