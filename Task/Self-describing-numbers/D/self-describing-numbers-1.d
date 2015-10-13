import std.stdio, std.algorithm, std.range, std.conv, std.string;

bool isSelfDescribing(in long n) pure nothrow @safe {
    auto nu = n.text.representation.map!q{ a - '0' };
    return nu.length.iota.map!(a => nu.count(a)).equal(nu);
}

void main() {
    4_000_000.iota.filter!isSelfDescribing.writeln;
}
