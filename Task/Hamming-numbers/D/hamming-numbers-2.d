import std.stdio, std.bigint, std.container, std.algorithm, std.range,
       core.memory;

BigInt hamming(in int n)
in {
   assert(n > 0);
} body {
    auto frontier = redBlackTree(2.BigInt, 3.BigInt, 5.BigInt);
    auto lowest = 1.BigInt;
    foreach (immutable _; 1 .. n) {
        lowest = frontier.front;
        frontier.removeFront;
        frontier.insert(lowest * 2);
        frontier.insert(lowest * 3);
        frontier.insert(lowest * 5);
    }
    return lowest;
}

void main() {
    GC.disable;
    writeln("First 20 Hamming numbers: ", iota(1, 21).map!hamming);
    writeln("hamming(1691) = ", 1691.hamming);
    writeln("hamming(1_000_000) = ", 1_000_000.hamming);
}
