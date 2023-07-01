int delegate(in int) nothrow ffr, ffs;

nothrow static this() {
    auto r = [0, 1], s = [0, 2];

    ffr = (in int n) nothrow {
        while (r.length <= n) {
            immutable int nrk = r.length - 1;
            immutable int rNext = r[nrk] + s[nrk];
            r ~= rNext;
            foreach (immutable sn; r[nrk] + 2 .. rNext)
                s ~= sn;
            s ~= rNext + 1;
        }
        return r[n];
    };

    ffs = (in int n) nothrow {
        while (s.length <= n)
            ffr(r.length);
        return s[n];
    };
}

void main() {
    import std.stdio, std.array, std.range, std.algorithm;

    iota(1, 11).map!ffr.writeln;
    auto t = iota(1, 41).map!ffr.chain(iota(1, 961).map!ffs);
    t.array.sort().equal(iota(1, 1001)).writeln;
}
