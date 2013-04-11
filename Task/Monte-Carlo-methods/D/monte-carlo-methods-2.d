import std.stdio, std.random, std.math, std.algorithm, std.range;

bool isIn(int){ return hypot(uniform(0,1.0), uniform(0,1.0)) <= 1; }

double pi(in int n) { return 4.0 * count!isIn(iota(n)) / n; }

void main() {
    foreach (p; 1 .. 8)
        writefln("%10s: %07f", 10 ^^ p, pi(10 ^^ p));
}
