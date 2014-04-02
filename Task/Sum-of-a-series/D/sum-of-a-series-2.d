import std.stdio, std.algorithm, std.range;

enum series(alias F) = (in int end, in int start=1) /*pure*/ =>
    iota(start, end + 1).map!F.sum;

void main() {
    writeln("Sum: ", series!q{1.0L / (a ^^ 2)}(1_000));
}
