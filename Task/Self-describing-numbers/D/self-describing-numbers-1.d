import std.stdio, std.algorithm, std.range, std.conv;

bool isSelfDescribing(in long n) /*pure nothrow*/ {
    auto nu = n.text.map!q{a - '0'};
    return nu.length.iota.map!(a => nu.count(a)).equal(nu);
}

void main() {
    4_000_000.iota.filter!isSelfDescribing.writeln;
}
