import std.stdio, std.traits;

auto powers(in double e) pure nothrow {
    double i = 0.0;
    return () => i++ ^^ e;
}

auto filter(D)(D af, D bf) if (isCallable!D) {
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
    auto fgen = filter(powers(2), powers(3));
    foreach (i; 0 .. 20)
        fgen();
    foreach (i; 0 .. 10)
        write(fgen(), " ");
    writeln();
}
