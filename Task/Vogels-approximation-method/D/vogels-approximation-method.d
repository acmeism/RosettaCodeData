void main() {
    import std.stdio, std.string, std.algorithm, std.range;

    enum K { A, B, C, D, E,  X, Y, Z, W }
    immutable int[K][K] costs = cast() //**
        [K.W: [K.A: 16, K.B: 16, K.C: 13, K.D: 22, K.E: 17],
         K.X: [K.A: 14, K.B: 14, K.C: 13, K.D: 19, K.E: 15],
         K.Y: [K.A: 19, K.B: 19, K.C: 20, K.D: 23, K.E: 50],
         K.Z: [K.A: 50, K.B: 12, K.C: 50, K.D: 15, K.E: 11]];
    int[K] demand, supply;
    with (K)
        demand = [A: 30, B: 20, C: 70, D: 30, E: 60],
        supply = [W: 50, X: 60, Y: 50, Z: 50];

    auto cols = demand.keys.sort().release;
    auto res = costs.byKey.zip((int[K]).init.repeat).assocArray;
    K[][K] g;
    foreach (immutable x; supply.byKey)
        g[x] = costs[x].keys.schwartzSort!(k => cast()costs[x][k]) //**
               .release;
    foreach (immutable x; demand.byKey)
        g[x] = costs.keys.schwartzSort!(k=> cast()costs[k][x]).release;

    while (g.length) {
        int[K] d, s;
        foreach (immutable x; demand.byKey)
            d[x] = g[x].length > 1 ?
                   costs[g[x][1]][x] - costs[g[x][0]][x] :
                   costs[g[x][0]][x];
        foreach (immutable x; supply.byKey)
            s[x] = g[x].length > 1 ?
                   costs[x][g[x][1]] - costs[x][g[x][0]] :
                   costs[x][g[x][0]];
        auto f = d.keys.minPos!((a,b) => d[a] > d[b])[0];
        auto t = s.keys.minPos!((a,b) => s[a] > s[b])[0];
        if (d[f] > s[t]) {
            t = f;
            f = g[f][0];
        } else {
            f = t;
            t = g[t][0];
        }
        immutable v = min(supply[f], demand[t]);
        res[f][t] += v;
        demand[t] -= v;
        if (demand[t] == 0) {
            foreach (immutable k, immutable n; supply)
                if (n != 0)
                    g[k] = g[k].remove!(c => c == t);
            g.remove(t);
            demand.remove(t);
        }
        supply[f] -= v;
        if (supply[f] == 0) {
            foreach (immutable k, immutable n; demand)
                if (n != 0)
                    g[k] = g[k].remove!(c => c == f);
            g.remove(f);
            supply.remove(f);
        }
    }

    writefln("%-(\t%s%)", cols);
    auto cost = 0;
    foreach (immutable c; costs.keys.sort().release) {
        write(c, '\t');
        foreach (immutable n; cols) {
            if (n in res[c]) {
                immutable y = res[c][n];
                if (y != 0) {
                    y.write;
                    cost += y * costs[c][n];
                }
            }
            '\t'.write;
        }
        writeln;
    }
    writeln("\nTotal Cost = ", cost);
}
