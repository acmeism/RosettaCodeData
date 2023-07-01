import std.stdio, std.algorithm, std.range, std.array;

auto forwardDifference(Range)(Range d, in int level) pure {
    foreach (immutable _; 0 .. level)
        d = d.zip(d.dropOne).map!(a => a[0] - a[1]).array;
    return d;
}

void main() {
    const data = [90.5, 47, 58, 29, 22, 32, 55, 5, 55, 73.5];
    foreach (immutable level; 0 .. data.length)
        forwardDifference(data, level).writeln;
}
