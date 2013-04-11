import std.stdio, std.algorithm, std.string, std.numeric;

auto checksum(string s) {
    auto m = s.map!q{ a>='0' && a<='9' ? a-'0' : a-'A'+10 }();
    return '0' + 10 - m.dotProduct([1,3,1,7,3,9]) % 10;
}

void main() {
    foreach (sedol; "710889 B0YBKJ 406566 B0YBLH 228276
                     B0YBKL 557910 B0YBKR 585284 B0YBKT".split())
        writeln(sedol, sedol.checksum());
}
