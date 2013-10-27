import std.stdio;

auto powers(in double e) pure nothrow {
    double i = 0;
    return () => i++ ^^ e;
}

auto filter2(D)(D af, D bf) {
    double a = af(), b = bf();

    return {
        double r;
        while (true) {
            if (a < b) {
                r = a;
                a = af();
                break;
            }
            if (b == a)
                a = af();
            b = bf();
        }
        return r;
    };
}

void main() {
    auto fgen = filter2(2.powers, 3.powers);
    foreach (immutable i; 0 .. 20)
        fgen();
    foreach (immutable i; 0 .. 10)
        write(fgen(), " ");
    writeln;
}
