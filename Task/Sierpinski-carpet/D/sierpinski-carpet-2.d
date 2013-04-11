import std.stdio, std.algorithm, std.range;

auto nextCarpet(in string[] c) /*pure nothrow*/ {
    const b = c.map!q{a ~ a ~ a}().array();
    return b ~ c.map!q{a ~ a.replace("#", " ") ~ a}().array() ~ b;
}

void main() {
    auto c = ["#"].recurrence!((a, n) => nextCarpet(a[n - 1]))();
    writefln("%-(%s\n%)", c.dropExactly(3).front);
}
