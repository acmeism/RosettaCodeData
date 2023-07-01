void main() {
    import std.stdio, std.container, std.range;

    auto dll = DList!dchar("DCBA"d.dup);

    dll[].writeln;
    dll[].retro.writeln;
}
