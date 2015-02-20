import std.stdio, std.string, std.math, std.array, std.algorithm;

struct SquareMat(T = creal) {
    public static string fmt = "%8.3f";
    private alias TM = T[][];
    private TM a;

    public this(in size_t side) pure nothrow @safe
    in {
        assert(side > 0);
    } body {
        a = new TM(side, side);
    }

    public this(in TM m) pure nothrow @safe
    in {
        assert(!m.empty);
        assert(m.all!(row => row.length == m.length)); // Is square.
    } body {
        // 2D dup.
        a.length = m.length;
        foreach (immutable i, const row; m)
            a[i] = row.dup;
    }

    string toString() const @safe {
        return format("<%(%(" ~ fmt ~ ", %)\n %)>", a);
    }

    public static SquareMat identity(in size_t side) pure nothrow @safe {
        auto m = SquareMat(side);
        foreach (immutable r, ref row; m.a)
            foreach (immutable c; 0 .. side)
                row[c] = (r == c) ? 1+0i : 0+0i;
        return m;
    }

    public SquareMat opBinary(string op:"*")(in SquareMat other)
    const pure nothrow @safe in {
        assert (a.length == other.a.length);
    } body {
        immutable side = other.a.length;
        auto d = SquareMat(side);
        foreach (immutable r; 0 .. side)
            foreach (immutable c; 0 .. side) {
                d.a[r][c] = 0+0i;
                foreach (immutable k, immutable ark; a[r])
                    d.a[r][c] += ark * other.a[k][c];
            }
        return d;
    }

    public SquareMat opBinary(string op:"^^")(int n) // The task part.
    const pure nothrow @safe in {
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
    alias M = SquareMat!();
    enum real q = 0.5.sqrt;
    immutable m = M([[   q + 0*1.0Li,    q + 0*1.0Li, 0.0L + 0.0Li],
                     [0.0L - q*1.0Li, 0.0L + q*1.0Li, 0.0L + 0.0Li],
                     [0.0L +   0.0Li, 0.0L +   0.0Li, 0.0L + 1.0Li]]);
    M.fmt = "%5.2f";
    foreach (immutable p; [0, 1, 23, 24])
        writefln("m ^^ %d =\n%s", p, m ^^ p);
}
