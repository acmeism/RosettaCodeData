import std.stdio, std.random, std.math;

double pi(in int nthrows) {
    int inside;
    foreach (i; 0 .. nthrows)
        if (hypot(uniform(0, 1.0), uniform(0, 1.0)) <= 1)
            inside++;
    return 4.0 * inside / nthrows;
}

void main() {
    foreach (p; 1 .. 8)
        writefln("%10s: %07f", 10 ^^ p, pi(10 ^^ p));
}
