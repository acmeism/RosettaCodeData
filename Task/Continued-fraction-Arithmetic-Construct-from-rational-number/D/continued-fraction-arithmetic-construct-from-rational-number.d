import std.concurrency;
import std.stdio;

struct Pair {
    int first, second;
}

auto r2cf(Pair frac) {
    return new Generator!int({
        auto num = frac.first;
        auto den = frac.second;
        while (den != 0) {
            auto div = num / den;
            auto rem = num % den;
            num = den;
            den = rem;
            div.yield();
        }
    });
}

void iterate(Generator!int seq) {
    foreach(i; seq) {
        write(i, " ");
    }
    writeln();
}

void main() {
    auto fracs = [
        Pair(   1,  2),
        Pair(   3,  1),
        Pair(  23,  8),
        Pair(  13, 11),
        Pair(  22,  7),
        Pair(-151, 77),
    ];
    foreach(frac; fracs) {
        writef("%4d / %-2d = ", frac.first, frac.second);
        frac.r2cf.iterate;
    }
    writeln;

    auto root2 = [
        Pair(    14_142,     10_000),
        Pair(   141_421,    100_000),
        Pair( 1_414_214,  1_000_000),
        Pair(14_142_136, 10_000_000),
    ];
    writeln("Sqrt(2) ->");
    foreach(frac; root2) {
        writef("%8d / %-8d = ", frac.first, frac.second);
        frac.r2cf.iterate;
    }
    writeln;

    auto pi = [
        Pair(         31,          10),
        Pair(        314,         100),
        Pair(      3_142,       1_000),
        Pair(     31_428,      10_000),
        Pair(    314_285,     100_000),
        Pair(  3_142_857,   1_000_000),
        Pair( 31_428_571,  10_000_000),
        Pair(314_285_714, 100_000_000),
    ];
    writeln("Pi ->");
    foreach(frac; pi) {
        writef("%9d / %-9d = ", frac.first, frac.second);
        frac.r2cf.iterate;
    }
}
