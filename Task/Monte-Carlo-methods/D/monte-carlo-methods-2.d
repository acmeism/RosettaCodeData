void main() {
    import std.stdio, std.random, std.math, std.algorithm, std.range;

    immutable isIn = (int) => hypot(uniform01, uniform01) <= 1;
    immutable pi = (in int n)  => 4.0 * n.iota.count!isIn / n;

    foreach (immutable p; 1 .. 8)
        writefln("%10s: %07f", 10 ^^ p, pi(10 ^^ p));
}
