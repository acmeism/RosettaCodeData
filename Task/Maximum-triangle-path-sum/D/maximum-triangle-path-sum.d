void main() {
    import std.stdio, std.algorithm, std.range, std.file, std.conv;

    "triangle.txt".File.byLine.map!split.map!(to!(int[])).array.retro
    .reduce!((x, y) => zip(y, x, x.dropOne)
                       .map!(t => t[0] + t[1 .. $].max)
                       .array)[0]
    .writeln;
}
