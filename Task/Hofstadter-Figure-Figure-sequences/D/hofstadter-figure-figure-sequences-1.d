import std.stdio, std.array, std.range, std.algorithm;

int delegate(in int) nothrow ffr, ffs;

static this() {
    auto r = [0, 1], s = [0, 2];

    ffr = (in int n) {
        while (r.length <= n) {
            int nrk = r.length - 1;
            int rNext = r[nrk] + s[nrk];
            r ~= rNext;
            foreach (sn; r[nrk] + 2 .. rNext)
                s ~= sn;
            s ~= rNext + 1;
        }
        return r[n];
    };

    ffs = (in int n) {
        while (s.length <= n)
            ffr(r.length);
        return s[n];
    };
}

void main() {
    writeln(iota(1, 11).map!ffr());
    auto t = iota(1, 41).map!ffr().chain(iota(1, 961).map!ffs());
    writeln(t.array().sort().equal(iota(1, 1001)));
}
