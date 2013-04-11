import std.stdio;

T[][] transpose(T)(immutable /*in*/ T[][] m) pure nothrow {
    auto r = new typeof(return)(m[0].length, m.length);
    foreach (nr, row; m)
        foreach (nc, c; row)
            r[nc][nr] = c;
    return r;
}

void main() {
    immutable M = [[10, 11, 12, 13],
                   [14, 15, 16, 17],
                   [18, 19, 20, 21]];
    immutable T = transpose(M);
    writefln("%(%(%2d %)\n%)", T);
}
