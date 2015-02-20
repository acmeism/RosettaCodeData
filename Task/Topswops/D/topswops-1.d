import std.stdio, std.algorithm, std.range, permutations2;

int topswops(in int n) pure @safe {
    static int flip(int[] xa) pure nothrow @safe @nogc {
        if (!xa[0]) return 0;
        xa[0 .. xa[0] + 1].reverse();
        return 1 + flip(xa);
    }
    return n.iota.array.permutations.map!flip.reduce!max;
}

void main() {
    foreach (immutable i; 1 .. 11)
        writeln(i, ": ", i.topswops);
}
