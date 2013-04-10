import std.stdio, std.algorithm, std.range;

auto mean(Range)(Range r) {
    auto len = r.walkLength();
    return len == 0 ? 0.0 : reduce!q{a + b}(0.0L, r) / len;
}

void main() {
    int[] data;
    writeln("mean: ", data.mean());
    data = [3, 1, 4, 1, 5, 9];
    writeln("mean: ", data.mean());
}
