module combinations4;
import std.stdio, std.algorithm, std.conv;

ulong choose(int n, int k) nothrow
in {
    assert(n >= 0 && k >= 0, "choose: no negative input.");
} body {
    static ulong[][] cache;

    if (n < k)
        return 0;
    else if (n == k)
        return 1;
    while (n >= cache.length)
        cache ~= [1UL]; // = choose(m, 0);
    auto kmax  = min(k, n - k);
    while(kmax >= cache[n].length) {
        immutable h = cache[n].length;
        cache[n] ~= choose(n - 1, h - 1) + choose(n - 1, h);
    }

    return cache[n][kmax];
}

int largestV(in int p, in int q, in long r) nothrow
in {
    assert(p > 0 && q >= 0 && r >= 0, "largestV: no negative input.");
} body {
    auto v = p - 1;
    while (choose(v, q) > r)
        v--;
    return v;
}

struct Comb {
    immutable int n, m;

    @property size_t length() const /*nothrow*/ {
        return to!size_t(choose(n, m));
    }

    int[] opIndex(in size_t idx) const {
        if (m < 0 || n < 0)
            return [];
        if (idx >= length)
            throw new Exception("Out of bound");
        ulong x = choose(n, m) - 1 - idx;
        int a = n, b = m;
        auto res = new int[m];
        foreach (i; 0 .. m) {
            a = largestV(a, b, x);
            x = x - choose(a, b);
            b = b - 1;
            res[i] = n - 1 - a;
        }
        return res;
    }

    int opApply(int delegate(ref int[]) dg) const {
        int[] yield;

        foreach (i; 0 .. length) {
            yield = this[i];
            if (dg(yield))
                break;
        }

        return 0;
    }

    static auto On(T)(in T[] arr, in int m) {
        auto comb = Comb(arr.length, m);

        return new class {
            @property size_t length() const /*nothrow*/ {
                return comb.length;
            }

            int opApply(int delegate(ref T[]) dg) const {
                auto yield = new T[m];

                foreach (c; comb) {
                    foreach (idx; 0 .. m)
                        yield[idx] = arr[c[idx]];
                    if (dg(yield))
                        break;
                }

                return 0;
            }
        };
    }
}


version(combinations4_main)
    void main() {
        foreach (c; Comb.On([1, 2, 3], 2))
            writeln(c);
    }
