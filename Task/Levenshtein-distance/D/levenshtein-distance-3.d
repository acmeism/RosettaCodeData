import std.stdio, std.array, std.algorithm, std.functional;

ulong lDist(in string s, in string t) nothrow {
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
