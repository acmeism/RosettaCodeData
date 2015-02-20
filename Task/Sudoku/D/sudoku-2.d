import std.stdio, std.algorithm, std.range;

const(int)[] solve(immutable int[] s) pure nothrow @safe {
    immutable i = s.countUntil(0);
    if (i == -1)
        return s;

    enum B = (int i, int j) => i / 27 ^ j / 27 | (i%9 / 3 ^ j%9 / 3);
    immutable c = iota(81)
                  .filter!(j => !((i - j) % 9 * (i/9 ^ j/9) * B(i, j)))
                  .map!(j => s[j]).array;

    foreach (immutable v; 1 .. 10)
        if (!c.canFind(v)) {
            const r = solve(s[0 .. i] ~ v ~ s[i + 1 .. $]);
            if (!r.empty)
                return r;
        }
    return null;
}

void main() {
    immutable problem = [
        8, 5, 0, 0, 0, 2, 4, 0, 0,
        7, 2, 0, 0, 0, 0, 0, 0, 9,
        0, 0, 4, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 0, 7, 0, 0, 2,
        3, 0, 5, 0, 0, 0, 9, 0, 0,
        0, 4, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 8, 0, 0, 7, 0,
        0, 1, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 3, 6, 0, 4, 0];
    writefln("%(%s\n%)", problem.solve.chunks(9));
}
