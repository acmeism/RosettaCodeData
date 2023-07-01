import std.stdio: writefln;
import std.bigint: BigInt;
import std.conv: text;
import std.algorithm: map;
import std.array: array;
import core.stdc.stdlib: malloc, calloc, free;
import std.math: log; // ^^

// Number of factors.
enum NK = 3;

__gshared immutable int[NK] primes = [2, 3, 5];
__gshared immutable double[NK] lnPrimes = primes[].map!log.array;

/// K-smooth numbers (stored as their exponents of each factor).

struct Hamming {
    double ln; // Log of the number.
    ushort[NK] e; // Exponents of each factor.
    Hamming* next;
    size_t n;

    // Recompute the logarithm from the exponents.
    void recalculate() pure nothrow @safe @nogc {
        this.ln = 0.0;
        foreach (immutable i, immutable ei; this.e)
            this.ln += lnPrimes[i] * ei;
    }

    string toString() const {
        BigInt result = 1;
        foreach (immutable i, immutable f; primes)
            result *= f.BigInt ^^ this.e[i];
        return result.text;
    }
}

Hamming getHam(in size_t n) nothrow @nogc
in {
    assert(n && n != size_t.max);
} body {
    static struct Candidate {
        typeof(Hamming.ln) ln;
        typeof(Hamming.e) e;

        void increment(in size_t n) pure nothrow @safe @nogc {
            e[n] += 1;
            ln += lnPrimes[n];
        }

        bool opEquals(T)(in ref T y) const pure nothrow @safe @nogc {
            // return this.e == y.e; // Slow.
            return !((this.e[0] ^ y.e[0]) |
                     (this.e[1] ^ y.e[1]) |
                     (this.e[2] ^ y.e[2]));
        }

        int opCmp(T)(in ref T y) const pure nothrow @safe @nogc {
            return (ln > y.ln) ? 1 : (ln < y.ln ? -1 : 0);
        }
    }

    static struct HammingIterator { // Not a Range.
        Candidate cand;
        Hamming* base;
        size_t primeIdx;

        this(in size_t i, Hamming* b) pure nothrow @safe @nogc {
            primeIdx = i;
            base = b;
            cand.e = base.e;
            cand.ln = base.ln;
            cand.increment(primeIdx);
        }

        void next() pure nothrow @safe @nogc {
            base = base.next;
            cand.e = base.e;
            cand.ln = base.ln;
            cand.increment(primeIdx);
        }
    }

    HammingIterator[NK] its;
    Hamming* head = cast(Hamming*)calloc(Hamming.sizeof, 1);
    Hamming* freeList, cur = head;
    Candidate next;

    foreach (immutable i, ref it; its)
        it = HammingIterator(i, cur);

    for (size_t i = cur.n = 1; i < n; ) {
        auto leastReferenced = size_t.max;
        next.ln = double.max;
        foreach (ref it; its) {
            if (it.cand == *cur)
                it.next;
            if (it.base.n < leastReferenced)
                leastReferenced = it.base.n;
            if (it.cand < next)
                next = it.cand;
        }

        // Collect unferenced numbers.
        while (head.n < leastReferenced) {
            auto tmp = head;
            head = head.next;
            tmp.next = freeList;
            freeList = tmp;
        }

        if (!freeList) {
            cur.next = cast(Hamming*)malloc(Hamming.sizeof);
        } else {
            cur.next = freeList;
            freeList = freeList.next;
        }

        cur = cur.next;
        version (fastmath) {
            cur.ln = next.ln;
            cur.e = next.e;
        } else {
            cur.e = next.e;
            cur.recalculate; // Prevent FP error accumulation.
        }

        cur.n = i++;
        cur.next = null;
    }

    auto result = *cur;
    version (leak) {}
    else {
        while (head) {
            auto tmp = head;
            head = head.next;
            tmp.free;
        }

        while (freeList) {
            auto tmp = freeList;
            freeList = freeList.next;
            tmp.free;
        }
    }

    return result;
}

void main() {
    foreach (immutable n; [1691, 10 ^^ 6, 10_000_000])
        writefln("%8d: %s", n, n.getHam);
}
