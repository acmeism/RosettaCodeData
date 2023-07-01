import std.stdio, std.algorithm, std.range, std.functional;

uint step(uint x) pure nothrow @safe @nogc {
    uint total = 0;
    while (x) {
        total += (x % 10) ^^ 2;
        x /= 10;
    }
    return total;
}

uint iterate(in uint x) nothrow @safe {
    return (x == 89 || x == 1) ? x : x.step.memoize!iterate;
}

void main() {
    iota(1, 100_000_000).filter!(x => x.iterate == 89).count.writeln;
}
