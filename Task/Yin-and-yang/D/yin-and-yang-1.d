import std.stdio, std.algorithm, std.array, std.math, std.range,
       std.conv, std.typecons;

string yinYang(in int n) {
    enum : char { empty = ' ', white = '.', black = '#' }
    const radii = [1, 3, 6].map!(i => i * n).array;
    auto ranges = radii.map!(r => iota(-r, r + 1).array).array;
    alias V = Tuple!(int,"x", int,"y");
    V[][] squares, circles;
    squares = ranges.map!(r=> cartesianProduct(r,r).map!V.array).array;
    foreach (sqrPoints, radius; zip(squares, radii))
        circles ~= sqrPoints.filter!(p => p[].hypot <= radius).array;
    auto m = squares[$ - 1].zip(empty.repeat).assocArray;
    foreach (p; circles[$ - 1])
        m[p] = black;
    foreach (p; circles[$ - 1])
        if (p.x > 0)
            m[p] = white;
    foreach (p; circles[$ - 2]) {
        m[V(p.x, p.y + 3 * n)] = black;
        m[V(p.x, p.y - 3 * n)] = white;
    }
    foreach (p; circles[$ - 3]) {
        m[V(p.x, p.y + 3 * n)] = white;
        m[V(p.x, p.y - 3 * n)] = black;
    }
    return ranges[$ - 1]
           .map!(y => ranges[$ - 1].retro.map!(x => m[V(x, y)]).text)
           .join("\n");
}

void main() {
    2.yinYang.writeln;
    1.yinYang.writeln;
}
