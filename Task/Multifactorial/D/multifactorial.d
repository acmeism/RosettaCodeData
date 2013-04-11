import std.stdio, std.algorithm, std.range;

T multifactorial(T=long)(in int n, in int m) /*pure*/ {
    T one = 1;
    return reduce!q{a * b}(one, iota(n, 0, -m));
}

void main() {
    foreach (m; 1 .. 11)
        writefln("%2d: %s", m, iota(1, 11)
                               .map!(n => multifactorial(n, m))());
}
