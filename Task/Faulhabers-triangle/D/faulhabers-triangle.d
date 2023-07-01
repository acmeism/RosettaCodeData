import std.algorithm : fold;
import std.conv : to;
import std.exception : enforce;
import std.format : formattedWrite;
import std.numeric : cmp, gcd;
import std.range : iota;
import std.stdio;
import std.traits;

auto abs(T)(T val)
if (isNumeric!T) {
    if (val < 0) {
        return -val;
    }
    return val;
}

struct Frac {
    long num;
    long denom;

    enum ZERO = Frac(0, 1);
    enum ONE = Frac(1, 1);

    this(long n, long d) in {
        enforce(d != 0, "Parameter d may not be zero.");
    } body {
        auto nn = n;
        auto dd = d;
        if (nn == 0) {
            dd = 1;
        } else if (dd < 0) {
            nn = -nn;
            dd = -dd;
        }
        auto g = gcd(abs(nn), abs(dd));
        if (g > 1) {
            nn /= g;
            dd /= g;
        }
        num = nn;
        denom = dd;
    }

    auto opBinary(string op)(Frac rhs) const {
        static if (op == "+" || op == "-") {
            return mixin("Frac(num*rhs.denom"~op~"denom*rhs.num, rhs.denom*denom)");
        } else if (op == "*") {
            return Frac(num*rhs.num, denom*rhs.denom);
        }
    }

    auto opUnary(string op : "-")() const {
        return Frac(-num, denom);
    }

    int opCmp(Frac rhs) const {
        return cmp(cast(real) this, cast(real) rhs);
    }

    bool opEquals(Frac rhs) const {
        return num == rhs.num && denom == rhs.denom;
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        if (denom == 1) {
            formattedWrite(sink, "%d", num);
        } else {
            formattedWrite(sink, "%d/%s", num, denom);
        }
    }

    T opCast(T)() const if (isFloatingPoint!T) {
        return cast(T) num / denom;
    }
}

auto abs(Frac f) {
    if (f.num >= 0) {
        return f;
    }
    return -f;
}

auto bernoulli(int n) in {
    enforce(n >= 0, "Parameter n must not be negative.");
} body {
    Frac[] a;
    a.length = n+1;
    a[0] = Frac.ZERO;
    foreach (m; 0..n+1) {
        a[m] = Frac(1, m+1);
        foreach_reverse (j; 1..m+1) {
            a[j-1] = (a[j-1] - a[j]) * Frac(j, 1);
        }
    }
    if (n != 1) {
        return a[0];
    }
    return -a[0];
}

auto binomial(int n, int k) in {
    enforce(n>=0 && k>=0 && n>=k);
} body {
    if (n==0 || k==0) return 1;
    auto num = iota(k+1, n+1).fold!"a*b"(1);
    auto den = iota(2, n-k+1).fold!"a*b"(1);
    return num / den;
}

Frac[] faulhaberTriangle(int p) {
    Frac[] coeffs;
    coeffs.length = p+1;
    coeffs[0] = Frac.ZERO;
    auto q = Frac(1, p+1);
    auto sign = -1;
    foreach (j; 0..p+1) {
        sign *= -1;
        coeffs[p - j] = q * Frac(sign, 1) * Frac(binomial(p+1, j), 1) * bernoulli(j);
    }
    return coeffs;
}

void main() {
    foreach (i; 0..10) {
        auto coeffs = faulhaberTriangle(i);
        foreach (coeff; coeffs) {
            writef("%5s  ", coeff.to!string);
        }
        writeln;
    }
    writeln;
}
