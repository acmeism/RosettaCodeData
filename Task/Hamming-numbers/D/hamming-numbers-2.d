import std.stdio,std.bigint,std.container,std.algorithm,std.range;

BigInt hamming(int n)
in {
   assert(n > 0);
} body {
    auto frontier = redBlackTree(BigInt(2), BigInt(3), BigInt(5));
    auto lowest = BigInt(1);
    foreach (_; 1 .. n) {
        lowest = frontier.front();
        frontier.removeFront();
        frontier.insert(lowest * 2);
        frontier.insert(lowest * 3);
        frontier.insert(lowest * 5);
    }
    return lowest;
}

void main() {
    writeln("First 20 Hamming numbers: ", map!hamming(iota(1, 21)));
    writeln("hamming(1691) = ", hamming(1691));
    writeln("hamming(1_000_000) = ", hamming(1_000_000));
}
