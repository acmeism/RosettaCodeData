import std.stdio, std.random, std.math, std.algorithm, std.range;

enum isIn = (int) => hypot(uniform(0, 1.0), uniform(0, 1.0)) <= 1;
enum pi = (in int n)  => 4.0 * n.iota.count!isIn / n;

void main() {
    foreach (immutable p; 1 .. 8)
        writefln("%10s: %07f", 10 ^^ p, pi(10 ^^ p));
}
