import std.stdio, std.algorithm, std.typecons, std.range, std.array;

int[][] zigZag(int n) {
    alias P2 = Tuple!(int,"x", int,"y");
    auto L = iota(n ^^ 2).map!(i => P2(i % n, i / n)).array;

    L.sort!q{ (a.x + a.y == b.x + b.y) ?
              ((a.x + a.y) % 2 ? a.y < b.y : a.x < b.x) :
              (a.x + a.y) < (b.x + b.y) };

    auto result = new typeof(return)(n, n);
    foreach (i, p; L)
        result[p.y][p.x] = i;
    return result;
}

void main() {
    writefln("%(%(%2d %)\n%)", 5.zigZag);
}
