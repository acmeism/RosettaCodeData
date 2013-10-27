import std.stdio, std.algorithm, std.range;

auto transpose(T)(in T[][] m) /*pure nothrow*/ {
    return m[0].length.iota.map!(i => m.transversal(i));
}

void main() {
    immutable M = [[10, 11, 12, 13],
                   [14, 15, 16, 17],
                   [18, 19, 20, 21]];
    /*immutable*/ auto T = M.transpose;
    writefln("%(%(%2d %)\n%)", T);
}
