module combinations3;

ulong binomial(long n, long k) pure nothrow
in {
    assert(n > 0, "binomial: n must be > 0.");
} body {
    if (k < 0 || k > n)
        return 0;
    if (k > (n / 2))
        k = n - k;
    ulong result = 1;
    foreach (ulong d; 1 .. k + 1) {
        result *= n;
        n--;
        result /= d;
    }
    return result;
}


struct Combinations(T, bool copy=true) {
    // Algorithm by Knuth, Pre-fascicle 3A, draft of
    // section 7.2.1.3: "Generating all partitions".
    T[] items;
    int k;
    size_t len = -1; // computed lazily

    this(in T[] items, in int k)
    in {
        assert(items.length, "combinations: items can't be empty.");
    } body {
        this.items = items.dup;
        this.k = k;
    }

    @property size_t length() /*logic_const*/ {
        if (len == -1) // set cache
            len = cast(size_t)binomial(items.length, k);
        return len;
    }

    int opApply(int delegate(ref T[]) dg) {
        if (k == items.length)
            return dg(items);         // yield items

        auto outarr = new T[k];
        if (k == 0)
            return dg(outarr);        // yield []

        if (k < 0 || k > items.length)
            return 0;                 // yield nothing

        int result, x;
        immutable n = items.length;
        auto c = new uint[k + 3]; // c[0] isn'k used

        foreach (j; 1 .. k + 1)
            c[j] = j - 1;
        c[k + 1] = n;
        c[k + 2] = 0;
        int j = k;

        while (true) {
            // The following lines equal to:
            //int pos;
            //foreach (i; 1 .. k +1)
            //    outarr[pos++] = items[c[i]];
            auto outarr_ptr = outarr.ptr;
            auto c_ptr = &(c[1]);
            auto c_ptrkp1 = &(c[k + 1]);
            while (c_ptr != c_ptrkp1)
                *outarr_ptr++ = items[*c_ptr++];


            static if (copy) {
                auto outarr2 = outarr.dup;
                result = dg(outarr2); // yield outarr2
            } else {
                result = dg(outarr); // yield outarr
            }

            if (j > 0) {
                x = j;
                c[j] = x;
                j--;
                continue;
            }

            if ((c[1] + 1) < c[2]) {
                c[1]++;
                continue;
            } else
                j = 2;

            while (true) {
                c[j - 1] = j - 2;
                x = c[j] + 1;
                if (x == c[j + 1])
                    j++;
                else
                    break;
            }

            if (j > k)
                return result; // End

            c[j] = x;
            j--;
        }
    }
}

Combinations!(T,copy) combinations(bool copy=true, T)
                                  (in T[] items, in int k)
in {
    assert(items.length, "combinations: items can't be empty.");
} body {
    return Combinations!(T, copy)(items, k);
}


// compile with -version=combinations3_main to run main
version(combinations3_main) void main() {
    import std.stdio, std.array;
    writeln(array(combinations([1, 2, 3, 4], 2)));
}
