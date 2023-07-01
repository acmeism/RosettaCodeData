import std.stdio, std.random, std.math, std.range, std.algorithm,
       statistics_basic;

struct Normals {
    double mu, sigma;
    double[2] state;
    size_t index = state.length;
    enum empty = false;

    void popFront() pure nothrow { index++; }

    @property double front() {
        if (index >= state.length) {
            immutable r = sqrt(-2 * uniform!"]["(0., 1.0).log) * sigma;
            immutable x = 2 * PI * uniform01;
            state = [mu + r * x.sin, mu + r * x.cos];
            index = 0;
        }
        return state[index];
    }
}

void main() {
    const data = Normals(0.0, 0.5).take(100_000).array;
    writefln("Mean: %8.6f, SD: %8.6f\n", data.meanStdDev[]);
    data.map!q{ max(0.0, min(0.9999, a / 3 + 0.5)) }.showHistogram01;
}
