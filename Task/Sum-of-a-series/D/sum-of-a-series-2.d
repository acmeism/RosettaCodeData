import std.stdio, std.algorithm, std.range;

auto series(alias F)(in int end, in int start=1) pure {
    return iota(start, end + 1).map!F.reduce!q{a + b};
}

void main() {
    writeln("Sum: ", series!q{1.0L / (a ^^ 2)}(1_000));
}
