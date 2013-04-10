import std.stdio, std.algorithm, std.range, std.functional;

auto amean(T)(T data) {
    return data.reduce!q{a + b}() / data.length;
}

auto gmean(T)(T data) {
    return data.reduce!q{a * b}() ^^ (1.0 / data.length);
}

auto hmean(T)(T data) {
    return data.length / data.reduce!q{1.0/a + b}();
}

void main() {
    auto m = adjoin!(hmean, gmean, amean)(iota(1.0L, 11.0L));
    writefln("%.19f %.19f %.19f", m.tupleof);
    assert([m.tupleof].isSorted());
}
