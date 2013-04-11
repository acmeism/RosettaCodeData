import std.stdio, std.algorithm, std.typecons, std.array,
       std.conv, std.range, std.traits;

auto derangementsR(in size_t n, in bool countOnly=false) {
    auto seq = iota(n).array();
    immutable ori = seq.idup;
    const(size_t[])[] res;
    size_t cnt;

    void perms(in size_t[] s, in size_t[] pre=null) nothrow {
        if (s.length) {
            foreach (i, c; s)
               perms(s[0 .. i] ~ s[i + 1 .. $], pre ~ c);
        } else if (mismatch!q{a != b}(pre, ori)[0].length == 0) {
            if (countOnly) cnt++;
            else res ~= pre;
        }
    }

    perms(seq);
    return tuple(res, cnt);
}

T fact(T)(in T n) pure nothrow {
    Unqual!T result = 1;
    for (Unqual!T i = 2; i <= n; i++)
        result *= i;
    return result;
}

T subfact(T)(in T n) pure nothrow {
    if (0 <= n && n <= 2)
        return n != 1;
    return (n - 1) * (subfact(n - 1) + subfact(n - 2));
}

void main() {
    writeln("derangements for n = 4\n");
    foreach (const d; derangementsR(4)[0])
        writeln(d);

    writeln("\ntable of n vs counted vs calculated derangements\n");
    foreach (i; 0 .. 10)
        writefln("%s  %-7s%-7s", i, derangementsR(i,1)[1], subfact(i));

    writefln("\n!20 = %s", subfact(20L));
}
