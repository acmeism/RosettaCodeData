import std.stdio, std.algorithm, std.range, std.conv;

bool isSelfDescribing(in long n) {
    auto nu = n.text().map!q{a - '0'}();
    return nu.equal( nu.length.iota().map!(a => count(nu, a))() );
}

void main() {
    writeln(iota(4_000_000).filter!isSelfDescribing());
}
