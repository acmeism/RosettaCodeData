import std.stdio, std.algorithm, std.random, std.range;

void main() {
    foreach (immutable i; 1 .. 9) {
        immutable s = iota(i * 2).map!(_ => "[]"[uniform(0, 2)]).array;
        writeln(s.balancedParens('[', ']') ? " OK: " : "bad: ", s);
    }
}
