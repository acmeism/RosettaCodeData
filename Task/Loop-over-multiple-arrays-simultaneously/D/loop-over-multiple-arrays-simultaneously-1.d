import std.stdio, std.range;

void main () {
    foreach (a, b, c; zip("abc", "ABC", [1, 2, 3]))
        writeln(a, b, c);
}
