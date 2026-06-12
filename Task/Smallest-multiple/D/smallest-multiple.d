import std.stdio : writefln;
import std.range: iota;
import std.algorithm: reduce;
import std.numeric: lcm;

void main() {
    const N=20;

    auto answer = iota(1, N+1).reduce!lcm;

    writefln("%,3?d", '_', answer);
}
