import std.stdio, std.algorithm, std.traits, std.range;

auto sumSquares(Range)(Range data) pure nothrow @safe @nogc {
    return reduce!q{a + b ^^ 2}(ForeachType!Range(0), data);
}

void main() {
    immutable items = [3.1, 1.0, 4.0, 1.0, 5.0, 9.0];
    items.sumSquares.writeln;
    10.iota.sumSquares.writeln;
}
