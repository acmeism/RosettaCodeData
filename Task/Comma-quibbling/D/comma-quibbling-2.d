import std.stdio, std.string, std.algorithm, std.conv, std.array;

enum quibbler = (in string[] a) pure =>
    "{%-(%s and %)}".format(a.length < 2 ? a :
                            [a[0 .. $-1].join(", "), a.back]);

void main() {
    [[], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]]
    .map!quibbler.writeln;
}
