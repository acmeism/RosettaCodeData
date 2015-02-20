import std.stdio, std.algorithm, std.range;

alias TRank = ulong;

TRank factorial(in uint n) pure nothrow {
    TRank result = 1;
    foreach (immutable i; 2 .. n + 1)
        result *= i;
    return result;
}

/// Fill the integer array <vec> with the permutation at rank <rank>.
void computePermutation(size_t N)(ref uint[N] vec, TRank rank)
pure nothrow if (N > 0 && N < 22) {
    N.iota.copy(vec[]);

    foreach_reverse (immutable n; 1 .. N + 1) {
        immutable size_t r = rank % n;
        rank /= n;
        swap(vec[r], vec[n - 1]);
    }
}

/// Return the rank of the current permutation.
TRank computeRank(size_t N)(in ref uint[N] vec) pure nothrow
if (N > 0 && N < 22) {
    uint[N] vec2, inv = void;

    TRank mrRank1(in uint n) nothrow {
        if (n < 2)
            return 0;

        immutable s = vec2[n - 1];
        swap(vec2[n - 1], vec2[inv[n - 1]]);
        swap(inv[s], inv[n - 1]);
        return s + n * mrRank1(n - 1);
    }

    vec2[] = vec[];
    foreach (immutable i; 0 .. N)
        inv[vec[i]] = i;
    return mrRank1(N);
}

void main() {
    import std.random;

    uint[4] items1 = void;
    immutable rMax1 = items1.length.factorial;
    for (TRank rank = 0; rank < rMax1; rank++) {
        items1.computePermutation(rank);
        writefln("%3d: %s = %d", rank, items1, items1.computeRank);
    }
    writeln;

    uint[21] items2 = void;
    immutable rMax2 = items2.length.factorial;
    foreach (immutable _; 0 .. 5) {
        immutable rank = uniform(0, rMax2);
        items2.computePermutation(rank);
        writefln("%20d: %s = %d", rank, items2, items2.computeRank);
    }
}
