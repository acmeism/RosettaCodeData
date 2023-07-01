import std.stdio, std.math, std.string;

enum bCoeff = 7;

struct Pt {
    double x, y;

    @property static Pt zero() pure nothrow @nogc @safe {
        return Pt(double.infinity, double.infinity);
    }

    @property bool isZero() const pure nothrow @nogc @safe {
        return x > 1e20 || x < -1e20;
    }

    @property static Pt fromY(in double y) nothrow /*pure*/ @nogc @safe {
        return Pt(cbrt(y ^^ 2 - bCoeff), y);
    }

    @property Pt dbl() const pure nothrow @nogc @safe {
        if (this.isZero)
            return this;
        immutable L = (3 * x * x) / (2 * y);
        immutable x2 = L ^^ 2  - 2 * x;
        return Pt(x2, L * (x - x2) - y);
    }

    string toString() const pure /*nothrow*/ @safe {
        if (this.isZero)
            return "Zero";
        else
            return format("(%.3f, %.3f)", this.tupleof);
    }

    Pt opUnary(string op)() const pure nothrow @nogc @safe
    if (op == "-") {
        return Pt(this.x, -this.y);
    }

    Pt opBinary(string op)(in Pt q) const pure nothrow @nogc @safe
    if (op == "+") {
        if (this.x == q.x && this.y == q.y)
            return this.dbl;
        if (this.isZero)
            return q;
        if (q.isZero)
            return this;
        immutable L = (q.y - this.y) / (q.x - this.x);
        immutable x = L ^^ 2 - this.x - q.x;
        return Pt(x, L * (this.x - x) - this.y);
    }

    Pt opBinary(string op)(in uint n) const pure nothrow @nogc @safe
    if (op == "*") {
        auto r = Pt.zero;
        Pt p = this;
        for (uint i = 1; i <= n; i <<= 1) {
            if ((i & n) != 0)
                r = r + p;
            p = p.dbl;
        }
        return r;
    }
}

void main() @safe {
    immutable a = Pt.fromY(1);
    immutable b = Pt.fromY(2);
    writeln("a = ", a);
    writeln("b = ", b);
    immutable c = a + b;
    writeln("c = a + b = ", c);
    immutable d = -c;
    writeln("d = -c = ", d);
    writeln("c + d = ", c + d);
    writeln("a + b + d = ", a + b + d);
    writeln("a * 12345 = ", a * 12345);
}
