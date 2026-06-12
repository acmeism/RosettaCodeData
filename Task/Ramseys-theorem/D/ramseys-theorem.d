import std.stdio, std.string, std.algorithm, std.range;

/// Generate the connectivity matrix.
immutable(char)[][] generateMatrix() {
    immutable r = format("-%b", 53643);
    return r.length.iota.map!(i => r[$-i .. $] ~ r[0 .. $-i]).array;
}

/**Check that every clique of four has at least one pair connected
and one pair unconnected. It requires a symmetric matrix.*/
string ramseyCheck(in char[][] mat) pure @safe
in {
    foreach (immutable r, const row; mat) {
        assert(row.length == mat.length);
        foreach (immutable c, immutable x; row)
            assert(x == mat[c][r]);
    }
} body {
    immutable N = mat.length;
    char[6] connectivity = '-';

    foreach (immutable a; 0 .. N) {
        foreach (immutable b; 0 .. N) {
            if (a == b) continue;
            connectivity[0] = mat[a][b];
            foreach (immutable c; 0 .. N) {
                if (a == c || b == c) continue;
                connectivity[1] = mat[a][c];
                connectivity[2] = mat[b][c];
                foreach (immutable d; 0 .. N) {
                    if (a == d || b == d || c == d) continue;
                    connectivity[3] = mat[a][d];
                    connectivity[4] = mat[b][d];
                    connectivity[5] = mat[c][d];

                    // We've extracted a meaningful subgraph,
                    // check its connectivity.
                    if (!connectivity[].canFind('0'))
                        return format("Fail, found wholly connected: ",
                                      a, " ", b," ", c, " ", d);
                    else if (!connectivity[].canFind('1'))
                        return format("Fail, found wholly " ~
                                      "unconnected: ",
                                      a, " ", b," ", c, " ", d);
                }
            }
        }
    }

    return "Satisfies Ramsey condition.";
}

void main() {
    const mat = generateMatrix;
    writefln("%-(%(%c %)\n%)", mat);
    mat.ramseyCheck.writeln;
}
