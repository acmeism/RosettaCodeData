import std.stdio: writefln;
import std.bigint: BigInt;
import std.conv: text;
import std.numeric: gcd;
import std.algorithm: copy, map;
import std.array: array;
import core.stdc.stdlib: calloc;
import std.math: log; // ^^

// Number of factors.
enum NK = 3;

enum MAX_HAM = 10_000_000;
static assert(gcd(NK, MAX_HAM) == 1);

enum int[NK] factors = [2, 3, 5];


/// K-smooth numbers (stored as their exponents of each factor).
struct Hamming {
    double v; // Log of the number, for convenience.
    ushort[NK] e; // Exponents of each factor.

    public static __gshared immutable double[factors.length] inc =
        factors[].map!log.array;

    bool opEquals(in ref Hamming y) const pure nothrow @nogc {
        //return this.e == y.e; // Too much slow.
        foreach (immutable i; 0 .. this.e.length)
            if (this.e[i] != y.e[i])
                return false;
        return true;
    }

    void update() pure nothrow @nogc {
        //this.v = dotProduct(inc, this.e); // Too much slow.
        this.v = 0.0;
        foreach (immutable i; 0 .. this.e.length)
            this.v += inc[i] * this.e[i];
    }

    string toString() const {
        BigInt result = 1;
        foreach (immutable i, immutable f; factors)
            result *= f.BigInt ^^ this.e[i];
        return result.text;
    }
}

// Global variables.
__gshared Hamming[] hams;
__gshared Hamming[NK] values;

nothrow @nogc static this() {
    // Slower than calloc if you don't use all the MAX_HAM items.
    //hams = new Hamming[MAX_HAM];

    auto ptr = cast(Hamming*)calloc(MAX_HAM, Hamming.sizeof);
    static const err = new Error("Not enough memory.");
    if (!ptr)
        throw err;
    hams = ptr[0 .. MAX_HAM];

    foreach (immutable i, ref v; values) {
        v.e[i] = 1;
        v.v = Hamming.inc[i];
    }
}


ref Hamming getHam(in size_t n) nothrow @nogc
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
            foreach (immutable i; 1 .. NK)
                if (values[i].v < values[ni].v)
                    ni = i;

            hams[n_hams] = values[ni];
            hams[n_hams].update;
        }

        foreach (immutable i; 0 .. NK)
            if (values[i] == hams[n_hams]) {
                values[i] = hams[idx[i]];
                idx[i]++;
                values[i].e[i]++;
                values[i].update;
            }
    }

    return hams[n - 2];
}


void main() {
    foreach (immutable n; [1691, 10 ^^ 6, MAX_HAM])
        writefln("%8d: %s", n, n.getHam);
}
