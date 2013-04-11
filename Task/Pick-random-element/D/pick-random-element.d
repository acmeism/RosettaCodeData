import std.stdio, std.random;

void main() {
    auto items = ["foo", "bar", "baz"];
    auto r = items[uniform(0, $)];
    writeln(r);
}
