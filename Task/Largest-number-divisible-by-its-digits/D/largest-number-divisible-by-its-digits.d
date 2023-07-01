import std.algorithm.iteration : filter, map;
import std.algorithm.searching : all;
import std.conv : to;
import std.range : iota;
import std.stdio : writeln;

bool chkDec(int num) {
    int[int] set;

    return num
        .to!string
        .map!(c => c.to!int - '0')
        .all!(d => (d != 0) && (num % d == 0) && set[d]++ < 1);
}

auto lcm(R)(R r) {
    return r.reduce!((a,b) => a * b / gcd(a,b));
}

void main() {
    // base 10
    iota(98764321, 0, -1)
        .filter!chkDec
        .front
        .writeln;
}
