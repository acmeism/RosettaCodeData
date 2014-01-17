T[][] transpose(T)(in T[][] m) pure nothrow {
    auto r = new typeof(return)(m[0].length, m.length);
    foreach (immutable nr, const row; m)
        foreach (immutable nc, immutable c; row)
            r[nc][nr] = c;
    return r;
}

void main() {
    import std.stdio;

    immutable M = [[10, 11, 12, 13],
                   [14, 15, 16, 17],
                   [18, 19, 20, 21]];
    writefln("%(%(%2d %)\n%)", M.transpose);
}
