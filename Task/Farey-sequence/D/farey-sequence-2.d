import std.stdio, std.algorithm, std.range, arithmetic_rational2;

auto farey(in int n) pure nothrow @safe {
    return rational(0, 1).only.chain(
            iota(1, n + 1)
            .map!(k => iota(1, k + 1).map!(m => rational(m, k)))
            .join.sort().uniq);
}

void main() @safe {
    writefln("Farey sequence for order 1 through 11:\n%(%s\n%)",
             iota(1, 12).map!farey);
    writeln("\nFarey sequence fractions, 100 to 1000 by hundreds:\n",
            iota(100, 1_001, 100).map!(i => i.farey.walkLength));
}
