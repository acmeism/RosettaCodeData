import std.stdio, std.algorithm, std.range;

enum say = (in string s) pure => s.group.map!q{ text(a[1],a[0]) }.join;

void main() {
    "1".recurrence!((t, n) => t[n - 1].say).take(8).writeln;
}
