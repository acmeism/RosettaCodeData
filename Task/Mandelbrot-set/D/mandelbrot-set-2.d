void main() {
    import std.stdio, std.complex, std.range, std.algorithm;

    foreach (immutable y; iota(-1.2, 1.2, 0.05))
        iota(-2.05, 0.55, 0.03).map!(x => 0.complex
            .recurrence!((a, n) => a[n - 1] ^^ 2 + complex(x, y))
            .drop(100).front.abs < 2 ? '#' : '.').writeln;
}
