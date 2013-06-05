import std.stdio, std.algorithm, std.range;

auto pascal() /*pure nothrow*/ {
    return [1].recurrence!q{ zip(a[n - 1] ~ 0, 0 ~ a[n - 1])
                             .map!q{a[0] + a[1]}
                             .array };
}

void main() {
    pascal.take(5).writeln;
}
