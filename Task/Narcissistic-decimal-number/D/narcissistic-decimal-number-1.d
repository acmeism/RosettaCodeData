void main() {
    import std.stdio, std.algorithm, std.conv, std.range;

    immutable isNarcissistic = (in uint n) pure @safe =>
        n.text.map!(d => (d - '0') ^^ n.text.length).sum == n;
    writefln("%(%(%d %)\n%)",
             uint.max.iota.filter!isNarcissistic.take(25).chunks(5));
}
