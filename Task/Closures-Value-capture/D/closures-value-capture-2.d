void main() {
    import std.stdio, std.range, std.algorithm;

    10.iota.map!(i => () => i ^^ 2).map!q{ a() }.writeln;
}
