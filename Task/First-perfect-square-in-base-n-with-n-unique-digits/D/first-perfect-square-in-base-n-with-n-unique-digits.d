import std.algorithm;
import std.exception;
import std.math;
import std.stdio;
import std.string;

string toBaseN(const long num, const int base)
in (base > 1, "base cannot be less than 2")
body {
    immutable ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    enforce(base < ALPHABET.length, "base cannot be represented");

    char[] result;
    long cnum = abs(num);
    while (cnum > 0) {
        auto rem = cast(uint) (cnum % base);
        result ~= ALPHABET[rem];
        cnum = (cnum - rem) / base;
    }

    if (num < 0) {
        result ~= '-';
    }
    return result.reverse.idup;
}

int countUnique(string buf) {
    bool[char] m;
    foreach (c; buf) {
        m[c] = true;
    }
    return m.keys.length;
}

void find(int base) {
    long nmin = cast(long) pow(cast(real) base, 0.5 * (base - 1));

    for (long n = nmin; /*blank*/; n++) {
        auto sq = n * n;
        enforce(n * n > 0, "Overflowed the square");
        string sqstr = toBaseN(sq, base);
        if (sqstr.length >= base && countUnique(sqstr) == base) {
            string nstr = toBaseN(n, base);
            writefln("Base %2d : Num %8s Square %16s", base, nstr, sqstr);
            return;
        }
    }
}

void main() {
    foreach (i; 2..17) {
        find(i);
    }
}
