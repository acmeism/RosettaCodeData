import std.stdio, std.algorithm, std.traits, std.range;

auto sumSquares(Range)(Range data) {
    return reduce!q{a + b ^^ 2}(cast(ForeachType!Range)0, data);
}

void main() {
    auto items = [3.1, 1.0, 4.0, 1.0, 5.0, 9.0];
    writeln(sumSquares(items));
    writeln(sumSquares(iota(10)));
}
