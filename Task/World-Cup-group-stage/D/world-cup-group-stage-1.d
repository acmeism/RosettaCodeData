void main() {
    import std.stdio, std.range, std.array, std.algorithm, combinations3;

    immutable scoring = [0, 1, 3];
    /*immutable*/ auto r3 = [0, 1, 2];
    immutable combs = 4.iota.array.combinations(2).array;
    uint[10][4] histo;

    foreach (immutable results; cartesianProduct(r3, r3, r3, r3, r3, r3)) {
        int[4] s;
        foreach (immutable r, const g; [results[]].zip(combs)) {
            s[g[0]] += scoring[r];
            s[g[1]] += scoring[2 - r];
        }

        foreach (immutable i, immutable v; s[].sort().release)
            histo[i][v]++;
    }
    writefln("%(%s\n%)", histo[].retro);
}
