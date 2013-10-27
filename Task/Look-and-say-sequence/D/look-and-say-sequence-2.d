import std.stdio, std.algorithm, std.conv, std.range;

string say(in string t) pure /*nothrow*/ {
    return t.group.map!q{ text(a[1], a[0]) }.join;
}

void main() {
    "1".recurrence!((t, n) => t[n - 1].say).take(8).writeln;
}
