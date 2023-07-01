import std.stdio, std.range, std.algorithm;

ulong[] combos(R)(R sides, in uint n) pure nothrow @safe
if (isForwardRange!R) {
    if (sides.empty)
        return null;
    if (!n)
        return [1];
    auto ret = new typeof(return)(reduce!max(sides[0], sides[1 .. $]) * n + 1);
    foreach (immutable i, immutable v; enumerate(combos(sides, n - 1))) {
        if (!v)
            continue;
        foreach (immutable s; sides)
            ret[i + s] += v;
    }
    return ret;
}

real winning(R)(R sides1, in uint n1, R sides2, in uint n2)
pure nothrow @safe if (isForwardRange!R) {
    static void accumulate(T)(T[] arr) pure nothrow @safe @nogc {
        foreach (immutable i; 1 .. arr.length)
            arr[i] += arr[i - 1];
    }

    immutable p1 = combos(sides1, n1);
    auto p2 = combos(sides2, n2);
    immutable s = p1.sum * p2.sum;
    accumulate(p2);
    ulong win = 0; // 'win' is 1 beating 2.
    foreach (immutable i, immutable x1; p1.dropOne.enumerate)
        win += x1 * p2[min(i, $ - 1)];
    return win / real(s);
}

void main() @safe {
    writefln("%1.16f", winning(iota(1u, 5u),  9, iota(1u, 7u), 6));
    writefln("%1.16f", winning(iota(1u, 11u), 5, iota(1u, 8u), 6));
}
