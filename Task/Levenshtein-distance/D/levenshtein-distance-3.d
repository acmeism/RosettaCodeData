import std.stdio, std.array, std.algorithm, std.functional;

uint lDist(T)(in const(T)[] s, in const(T)[] t) nothrow {
    alias mlDist = memoize!lDist;
    if (s.empty || t.empty) return max(t.length, s.length);
    if (s[0] == t[0]) return mlDist(s[1 .. $], t[1 .. $]);
    return min(mlDist(s, t[1 .. $]),
               mlDist(s[1 .. $], t),
               mlDist(s[1 .. $], t[1 .. $])) + 1;
}

void main() {
    lDist("kitten", "sitting").writeln;
    lDist("rosettacode", "raisethysword").writeln;
}
