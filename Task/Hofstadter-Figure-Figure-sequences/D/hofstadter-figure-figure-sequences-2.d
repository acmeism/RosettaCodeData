import std.stdio, std.array, std.range, std.algorithm;

struct ffr {
    static r = [int.min, 1];

    static int opCall(in int n) nothrow {
        assert(n > 0);
        if (n < r.length) {
            return r[n];
        } else {
            immutable int ffr_n_1 = ffr(n - 1);
            immutable int lastr = r[$ - 1];
            // Extend s up to, and one past, last r.
            ffs.s ~= iota(ffs.s[$ - 1] + 1, lastr).array;
            if (ffs.s[$ - 1] < lastr)
                ffs.s ~= lastr + 1;
            // Access s[n - 1] temporarily extending s if necessary.
            immutable size_t len_s = ffs.s.length;
            immutable int ffs_n_1 = (len_s > n) ?
                                    ffs.s[n - 1] :
                                    (n - len_s) + ffs.s[$ - 1];
            immutable int ans = ffr_n_1 + ffs_n_1;
            r ~= ans;
            return ans;
        }
    }
}

struct ffs {
    static s = [int.min, 2];

    static int opCall(in int n) nothrow {
        assert(n > 0);
        if (n < s.length) {
            return s[n];
        } else {
            foreach (immutable i; ffr.r.length .. n + 2) {
                ffr(i);
                if (s.length > n)
                    return s[n];
            }
            assert(false, "Whoops!");
        }
    }
}

void main() {
    iota(1, 11).map!ffr.writeln;
    auto t = iota(1, 41).map!ffr.chain(iota(1, 961).map!ffs);
    t.array.sort().equal(iota(1, 1001)).writeln;
}
