import std.stdio, std.algorithm, std.range, std.random;
alias R = std.array.replicate;

void main() {
    enum int w = 14, h = 10;
    auto vis = new bool[][](h, w),
         hor = iota(h + 1).map!(_ => ["+---"].R(w)).array,
         ver = h.iota.map!(_ => ["|   "].R(w) ~ "|").array;

    void walk(in int x, in int y) /*nothrow*/ {
        vis[y][x] = true;
        static struct P { immutable uint x, y; } // Will wrap-around.
        auto d = [P(x-1, y), P(x, y+1), P(x+1, y), P(x, y-1)];
        foreach (p; d.randomCover(unpredictableSeed.Random)) {
            if (p.x >= w || p.y >= h || vis[p.y][p.x]) continue;
            if (p.x == x) hor[max(y, p.y)][x] = "+   ";
            if (p.y == y) ver[y][max(x, p.x)] = "    ";
            walk(p.tupleof);
        }
    }
    walk(uniform(0, w), uniform(0, h));
    foreach (a, b; hor.zip(ver ~ []))
        join(a ~ ["+\n"] ~ b).writeln;
}
