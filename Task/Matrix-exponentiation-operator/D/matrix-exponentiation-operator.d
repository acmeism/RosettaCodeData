import std.stdio, std.string, std.math, std.array;

struct SquareMat(T = creal) {
    static public string fmt = "%8.3f";
    private alias T[][] TM;
    private TM a;

    public this(in size_t side) pure nothrow
    in {
        assert(side > 0);
    } body {
        a = new TM(side, side);
    }

    public this(in TM m) pure nothrow
    in {
        assert(!m.empty);
        foreach (row; m)
            assert(m.length == m[0].length);
    } body {
        a.length = m.length;
        foreach (i, row; m)
            //a[i] = row.dup; // not nothrow
            a[i] = row ~ []; // slower
    }

    string toString() const {
        return xformat("<%(%(" ~ fmt ~ ", %)\n %)>", a);
    }

    public static SquareMat identity(in size_t side) pure nothrow {
        SquareMat m;
        m.a.length = side;
        foreach (r, ref row; m.a) {
            row.length = side;
            foreach (c; 0 .. side)
                row[c] = cast(T)(r == c ? 1 : 0);
        }
        return m;
    }

    public SquareMat opBinary(string op:"*")(in SquareMat other)
    const pure nothrow in {
        assert (a.length == other.a.length);
    } body {
        immutable size_t side = other.a.length;
        SquareMat d;
        d.a = new TM(side, side);
        foreach (r; 0 .. side)
            foreach (c; 0 .. side) {
                d.a[r][c] = cast(T)0;
                foreach (k, ark; a[r])
                    d.a[r][c] += ark * other.a[k][c];
            }
        return d;
    }

    // This is the task part ---------------
    public SquareMat opBinary(string op:"^^")(int n) const pure nothrow
    in {
        assert(n >= 0, "Negative exponent not implemented.");
    } body {
        auto sq = SquareMat(this.a);
        auto d = SquareMat.identity(a.length);
        for (; n > 0; sq = sq * sq, n >>= 1)
            if (n & 1)
                d = d * sq;
        return d;
    }
}

void main() {
    alias SquareMat!() M;
    immutable real q = sqrt(0.5);
    auto m = M([[   q + 0*1.0Li,    q + 0*1.0Li, 0.0L + 0.0Li],
                [0.0L - q*1.0Li, 0.0L + q*1.0Li, 0.0L + 0.0Li],
                [0.0L +   0.0Li, 0.0L +   0.0Li, 0.0L + 1.0Li]]);
    M.fmt = "%5.2f";
    foreach (p; [0, 1, 23, 24])
        writefln("m ^^ %d =\n%s", p, m ^^ p);
}
