import std.stdio, std.algorithm, std.typecons, std.conv, std.range;

T factorial(T)(in T n) pure nothrow {
    Unqual!T result = 1;
    foreach (immutable i; 2 .. n + 1)
        result *= i;
    return result;
}

T subfact(T)(in T n) pure nothrow {
    if (0 <= n && n <= 2)
        return n != 1;
    return (n - 1) * (subfact(n - 1) + subfact(n - 2));
}

auto derangementsR(in size_t n, in bool countOnly=false)
pure /*nothrow*/ {
    auto seq = n.iota.array;
    immutable ori = seq.idup; // Not nothrow.
    const(size_t[])[] res;
    size_t cnt;

    void perms(in size_t[] s, in size_t[] pre=null) /*nothrow*/ {
        if (s.length) {
            foreach (immutable i, immutable c; s)
               perms(s[0 .. i] ~ s[i + 1 .. $], pre ~ c);
        } else if (zip(pre, ori).all!(po => po[0] != po[1])) {
            if (countOnly) cnt++;
            else res ~= pre;
        }
    }

    perms(seq);
    return tuple(res, cnt);
}

void main() {
    "Derangements for n = 4:".writeln;
    foreach (const d; 4.derangementsR[0])
        d.writeln;

    "\nTable of n vs counted vs calculated derangements:".writeln;
    foreach (immutable i; 0 .. 10)
        writefln("%s  %-7s%-7s", i, derangementsR(i, 1)[1], i.subfact);

    writefln("\n!20 = %s", 20L.subfact);
}
