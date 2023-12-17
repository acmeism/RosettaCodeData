import std.stdio;
import std.range;
import std.algorithm;

uint lpd(uint n) {
    if (n <= 1) {
        return 1;
    }

    auto divisors = array(iota(1, n).filter!(i => n % i == 0));

    return divisors.empty ? 1 : divisors[$ - 1];
}

void main() {
    foreach (i; 1 .. 101) {
        writef("%3d", lpd(i));

        if (i % 10 == 0) {
            writeln();
        }
    }
}
