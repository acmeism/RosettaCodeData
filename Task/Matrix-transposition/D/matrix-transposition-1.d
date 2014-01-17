void main() {
    import std.stdio, std.range;

    /*immutable*/ auto M = [[10, 11, 12, 13],
                            [14, 15, 16, 17],
                            [18, 19, 20, 21]];
    writefln("%(%(%2d %)\n%)", M.transposed);
}
