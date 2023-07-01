import std.stdio, std.range, std.algorithm, std.random, std.math;

enum n = 100, p = 0.5, t = 500;

double meanRunDensity(in size_t n, in double prob) {
    return n.iota.map!(_ => uniform01 < prob)
           .array.uniq.sum / double(n);
}

void main() {
    foreach (immutable p; iota(0.1, 1.0, 0.2)) {
        immutable limit = p * (1 - p);
        writeln;
        foreach (immutable n2; iota(10, 16, 2)) {
            immutable n = 2 ^^ n2;
            immutable sim = t.iota.map!(_ => meanRunDensity(n, p))
                            .sum / t;
            writefln("t=%3d, p=%4.2f, n=%5d, p(1-p)=%5.5f, " ~
                     "sim=%5.5f, delta=%3.1f%%", t, p, n, limit, sim,
                     limit ? abs(sim - limit) / limit * 100 : sim*100);
        }
    }
}
