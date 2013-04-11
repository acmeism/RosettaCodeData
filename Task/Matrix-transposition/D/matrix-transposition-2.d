import std.stdio, std.algorithm, std.range;

auto transpose(T)(in T[][] m) /*pure nothrow*/ {
    return iota(m[0].length).map!(i => transversal(m, i))();
}

void main() {
    enum M = [[10, 11, 12, 13],
              [14, 15, 16, 17],
              [18, 19, 20, 21]];
    /*immutable*/ auto T = transpose(M);
    writefln("%(%(%2d %)\n%)", T);
}
