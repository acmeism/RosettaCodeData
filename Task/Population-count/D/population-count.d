void main() {
    import std.stdio, std.algorithm, std.range, core.bitop;

    enum pCount = (ulong n) => popcnt(n & uint.max) + popcnt(n >> 32);
    writefln("%s\nEvil: %s\nOdious: %s",
             uint.max.iota.map!(i => pCount(3L ^^ i)).take(30),
             uint.max.iota.filter!(i => pCount(i) % 2 == 0).take(30),
             uint.max.iota.filter!(i => pCount(i) % 2).take(30));
}
