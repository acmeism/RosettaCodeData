void main() {
    import std.stdio, std.algorithm, std.range, std.file, std.string;

    auto words = "unixdict.txt".readText.split.filter!isSorted;
    immutable maxLen = words.map!q{a.length}.reduce!max;
    writefln("%-(%s\n%)", words.filter!(w => w.length == maxLen));
}
