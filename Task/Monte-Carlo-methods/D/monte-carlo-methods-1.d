import std.stdio, std.random, std.math;

double pi(in uint nthrows) /*nothrow*/ @safe /*@nogc*/ {
    uint inside;
    foreach (immutable i; 0 .. nthrows)
        if (hypot(uniform01, uniform01) <= 1)
            inside++;
    return 4.0 * inside / nthrows;
}

void main() {
    foreach (immutable p; 1 .. 8)
        writefln("%10s: %07f", 10 ^^ p, pi(10 ^^ p));
}
