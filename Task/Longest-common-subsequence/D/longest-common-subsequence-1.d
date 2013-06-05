import std.stdio, std.array;

T[] lcs(T)(in T[] a, in T[] b) pure nothrow {
    if (a.empty || b.empty) return null;
    if (a[0] == b[0])
        return a[0] ~ lcs(a[1 .. $], b[1 .. $]);
    const longest = (T[] x, T[] y) => x.length > y.length ? x : y;
    return longest(lcs(a, b[1 .. $]), lcs(a[1 .. $], b));
}

void main() {
    lcs("thisisatest", "testing123testing").writeln;
}
