import std.stdio, std.string, std.algorithm, std.typecons;

void main() {
    "here are Some sample strings to be sorted"
    .split
    .schwartzSort!q{ tuple(-a.length, a.toUpper) }
    .writeln;
}
