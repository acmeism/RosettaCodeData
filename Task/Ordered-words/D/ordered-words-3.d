import std.stdio, std.algorithm, std.range, std.file, std.string;

void main() {
    auto ws = "unixdict.txt".readText().split().filter!isSorted();
    immutable maxLen = ws.map!walkLength().reduce!max();
    writefln("%-(%s\n%)", ws.filter!(w => w.length == maxLen)());
}
