void main() {
    import std.stdio, std.complex;

    for (real y = -1.2; y < 1.2; y += 0.05) {
        for (real x = -2.05; x < 0.55; x += 0.03) {
            auto z = 0.complex;
            foreach (_; 0 .. 100)
                z = z ^^ 2 + complex(x, y);
            write(z.abs < 2 ? '#' : '.');
        }
        writeln;
    }
}
