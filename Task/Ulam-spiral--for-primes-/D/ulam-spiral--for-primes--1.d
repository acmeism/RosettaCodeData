import std.stdio, std.math, std.algorithm, std.array, std.range;

int cell(in int n, int x, int y, in int start=1) pure nothrow @safe @nogc {
    x = x - (n - 1) / 2;
    y = y - n / 2;
    immutable l = 2 * max(x.abs, y.abs);
    immutable d = (y > x) ? (l * 3 + x + y) : (l - x - y);
    return (l - 1) ^^ 2 + d + start - 1;
}

void showSpiral(in int n, in string symbol="# ", in int start=1, string space=null) /*@safe*/ {
    if (space is null)
        space = " ".replicate(symbol.length);

    immutable top = start + n ^^ 2 + 1;
    auto isPrime = [false, false, true] ~ [true, false].replicate(top / 2);
    foreach (immutable x; 3 .. 1 + cast(int)real(top).sqrt) {
        if (!isPrime[x])
            continue;
        foreach (immutable i; iota(x ^^ 2, top, x * 2))
            isPrime[i] = false;
    }

    string cellStr(in int x) pure nothrow @safe @nogc {
        return isPrime[x] ? symbol : space;
    }

    foreach (immutable y; 0 .. n)
        n.iota.map!(x => cell(n, x, y, start)).map!cellStr.joiner.writeln;
}

void main() {
    35.showSpiral;
}
