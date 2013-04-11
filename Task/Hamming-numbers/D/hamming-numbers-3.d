import std.stdio: writefln;
import std.bigint: BigInt, toDecimalString;
import std.numeric: gcd;
import std.algorithm: copy, map;
import std.math; // log, ^^

// Number of factors.
enum NK = 3;

enum MAX_HAM = 10_000_000;
static assert(gcd(NK, MAX_HAM) == 1);

enum int[NK] fac = [2, 3, 5];


/// k-smooth numbers (stored as their exponents of each factor).
struct Hamming {
    double v; // log of the number, for convenience.
    ushort[NK] e; // exponents of each factor.

    // Compile-time constant, map!log(fac)
    // log can't be used in CTFE yet
    public static __gshared const double[fac.length] inc;

    nothrow pure static this() {
        //map!log(fac[]).copy(inc[]); // Not nothrow, not const.
        foreach (i, f; fac)
            inc[i] = log(f);
    }

    bool opEquals(in ref Hamming y) const pure nothrow {
        //return this.e == y.e; // too much slow
        foreach (size_t i; 0 .. this.e.length)
            if (this.e[i] != y.e[i])
                return false;
        return true;
    }

    void update() pure nothrow {
        //this.v = dotProduct(inc, this.e); // too much slow
        this.v = 0.0;
        foreach (size_t i; 0 .. this.e.length)
            this.v += inc[i] * this.e[i];
    }

    string toString() const {
        BigInt result = 1;
        foreach (size_t i, f; fac)
            result *= BigInt(f) ^^ this.e[i];
        return toDecimalString(result);
    }
}

// Global variables.
__gshared Hamming[] hams;
__gshared Hamming[NK] values;


nothrow static this() {
    // Slower than malloc if you don't use all the MAX_HAM items.
    hams = new Hamming[MAX_HAM];

    foreach (i, ref v; values) {
        v.e[i] = 1;
        v.v = Hamming.inc[i];
    }
}


ref Hamming getHam(in size_t n) nothrow
in {
    assert(n <= MAX_HAM);
} body {
    // Most of the time v can be just incremented, but eventually
    // floating point precision will bite us, so better recalculate.
    __gshared static size_t[NK] idx;
    __gshared static int n_hams;

    for (; n_hams < n; n_hams++) {
        {
            // Find the index of the minimum v.
            size_t ni = 0;
            foreach (size_t i; 1 .. NK)
                if (values[i].v < values[ni].v)
                    ni = i;

            hams[n_hams] = values[ni];
            hams[n_hams].update();
        }

        foreach (size_t i; 0 .. NK)
            if (values[i] == hams[n_hams]) {
                values[i] = hams[idx[i]];
                idx[i]++;
                values[i].e[i]++;
                values[i].update();
            }
    }

    return hams[n - 2];
}


void main() {
    foreach (n; [1691, 10 ^^ 6, MAX_HAM])
        writefln("%8d: %s", n, getHam(n));
}
