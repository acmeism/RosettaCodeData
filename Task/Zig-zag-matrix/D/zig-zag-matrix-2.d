import std.stdio, std.algorithm, std.range, std.array;

int[][] zigZag(in int n) pure nothrow {
    static struct P2 { int x, y; }
    const L = iota(n ^^ 2).map!(i => P2(i % n, i / n)).array
              .sort!q{ (a.x + a.y == b.x + b.y) ?
                       ((a.x + a.y) % 2 ? a.y < b.y : a.x < b.x) :
                       (a.x + a.y) < (b.x + b.y) }.release;

    auto result = new typeof(return)(n, n);
    foreach (immutable i, immutable p; L)
        result[p.y][p.x] = i;
    return result;
}

void main() {
    writefln("%(%(%2d %)\n%)", 5.zigZag);
}
