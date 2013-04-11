import std.stdio, std.complex;

void main() {
    enum maxIter = 1_000;
    foreach (y; -39 .. 39) {
        foreach (x; -39 .. 39) {
            auto c = complex(y/40.0 - 0.5, x/40.0),
                 z = complex(0),
                 i = 0;
            for (; i < maxIter && z.abs() < 4; i++)
                z = z ^^ 2 + c;
            write(i == maxIter ? '#' : ' ');
        }
        writeln();
    }
}
