import std.stdio, std.algorithm, std.range, std.array;

auto forwardDifference(Range)(Range d, in int level) {
    foreach (_; 0 .. level)
        d = zip(d[1 .. $], d).map!q{ a[0] - a[1] }().array();
    return d;
}

void main() {
    auto data = [90.5, 47, 58, 29, 22, 32, 55, 5, 55, 73.5];
    foreach (level; 0 .. data.length)
        writeln(forwardDifference(data, level));
}
