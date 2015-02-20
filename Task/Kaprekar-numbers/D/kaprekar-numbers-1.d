import std.stdio, std.conv, std.algorithm, std.range;

bool isKaprekar(in long n) pure /*nothrow*/ @safe
in {
    assert(n > 0, "isKaprekar(n) is defined for n > 0.");
} body {
    if (n == 1)
        return true;
    immutable sn = text(n ^^ 2);

    foreach (immutable i; 1 .. sn.length) {
        immutable a = sn[0 .. i].to!long;
        immutable b = sn[i .. $].to!long;
        if (b && a + b == n)
            return true;
    }

    return false;
}

void main() {
    iota(1, 10_000).filter!isKaprekar.writeln;
    iota(1, 1_000_000).count!isKaprekar.writeln;
}
