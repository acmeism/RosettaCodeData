import std.stdio;

T[] lcs(T)(in T[] a, in T[] b) pure nothrow {
    if (!a.length || !b.length) return null;
    if (a[0] == b[0])
        return a[0] ~ lcs(a[1 .. $], b[1 .. $]);
    auto l1 = lcs(a, b[1 .. $]), l2 = lcs(a[1 .. $], b);
    return l1.length > l2.length ? l1 : l2;
}

void main() {
    writeln(lcs("thisisatest", "testing123testing"));
}
