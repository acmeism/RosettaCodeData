import std.stdio, std.array, std.range, std.algorithm;

struct ffr {
    static int[] r = [int.min, 1];

    static int opCall(in int n) {
        assert(n > 0);
        if (n < r.length) {
            return r[n];
        } else {
            int ffr_n_1 = ffr(n - 1);
            int lastr = r[$ - 1];
            // extend s up to, and one past, last r
            ffs.s ~= array(iota(ffs.s[$ - 1] + 1, lastr));
            if (ffs.s[$ - 1] < lastr)
                ffs.s ~= lastr + 1;
            // access s[n-1] temporarily extending s if necessary
            size_t len_s = ffs.s.length;
            int ffs_n_1 = len_s > n ? ffs.s[n - 1] :
                                      (n - len_s) + ffs.s[$-1];
            int ans = ffr_n_1 + ffs_n_1;
            r ~= ans;
            return ans;
        }
    }
}

struct ffs {
    static int[] s = [int.min, 2];

    static int opCall(in int n) {
        assert(n > 0);
        if (n < s.length) {
            return s[n];
        } else {
            foreach (i; ffr.r.length .. n+2) {
                ffr(i);
                if (s.length > n)
                    return s[n];
            }
            assert(0, "Whoops!");
        }
    }
}

void main() {
    writeln(map!ffr(iota(1, 11)));
    auto t = chain(map!ffr(iota(1, 41)), map!ffs(iota(1, 961)));
    writeln(equal(sort(array(t)), iota(1, 1001)));
}
