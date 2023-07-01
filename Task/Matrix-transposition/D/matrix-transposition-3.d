import std.stdio, std.algorithm, std.range, std.functional;

auto transpose(T)(in T[][] m) pure nothrow {
    return m[0].length.iota.map!(curry!(transversal, m));
}

void main() {
    immutable M = [[10, 11, 12, 13],
                   [14, 15, 16, 17],
                   [18, 19, 20, 21]];
    writefln("%(%(%2d %)\n%)", M.transpose);
}
