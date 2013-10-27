void main() {
    import std.stdio, std.complex, std.range;

    enum maxIter = 100;
    foreach (immutable y; iota(-1.2, 1.2, 0.05)) {
        foreach (immutable x; iota(-2.05, 0.55, 0.03)) {
            immutable c = complex(x, y);
            auto z = complex(0),
                 i = 0;
            for (; i < maxIter && z.abs < 4; i++)
                z = z ^^ 2 + c;
            write(i == maxIter ? '#' : '.');
        }
        writeln;
    }
}
