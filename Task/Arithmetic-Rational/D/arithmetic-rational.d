import std.bigint, std.traits, std.conv;

T gcd(T)(/*in*/ T a, /*in*/ T b) /*pure nothrow*/ {
    // std.numeric.gcd doesn't work with BigInt.
    return (b != 0) ? gcd(b, a % b) : (a < 0) ? -a : a;
}

T lcm(T)(/*in*/ T a, /*in*/ T b) {
    return a / gcd(a, b) * b;
}

struct RationalT(T) {
    /*const*/ private T num, den; // Numerator & denominator.

    private enum Type { NegINF = -2,
                        NegDEN = -1,
                        NaRAT  =  0,
                        NORMAL =  1,
                        PosINF =  2 };

    this(U : RationalT)(U n) pure nothrow {
        num = n.num;
        den = n.den;
    }

    this(U)(in U n) pure nothrow if (isIntegral!U) {
        num = toT(n);
        den = 1UL;
    }

    this(U, V)(/*in*/ U n, /*in*/ V d) /*pure nothrow*/ {
        num = toT(n);
        den = toT(d);
        /*const*/ T common = gcd(num, den);
        if (common != 0) {
            num /= common;
            den /= common;
        } else { // infinite or NOT a Number
            num = (num == 0) ? 0 : (num < 0) ? -1 : 1;
            den = 0;
        }
        if (den < 0) { // Assure den is non-negative.
            num = -num;
            den = -den;
        }
    }

    static T toT(U)(/*in*/ ref U n) pure nothrow if (is(U == T)) {
        return n;
    }

    static T toT(U)(in ref U n) pure nothrow if (!is(U == T)) {
        T result = n;
        return result;
    }

    T nomerator() /*const*/ pure nothrow @property {
        return num;
    }

    T denominator() /*const*/ pure nothrow @property {
        return den;
    }

    string toString() /*pure const*/ {
        if (den != 0)
            return num.text ~ (den == 1 ? "" : "/" ~ den.text);
        if (num == 0)
            return "NaRat";
        else
            return ((num < 0) ? "-" : "+") ~ "infRat";
    }

    real toReal() const {
        return num.toLong / cast(real)den.toLong;
    }

    RationalT opBinary(string op)(/*in*/ RationalT r)
    /*const pure nothrow*/ if (op == "+" || op == "-") {
        T common = lcm(den, r.den);
        T n = mixin("common / den * num" ~ op ~
                    "common / r.den * r.num" );
        return RationalT(n, common);
    }

    RationalT opBinary(string op)(/*in*/ RationalT r)
    /*const pure nothrow*/ if (op == "*") {
        return RationalT(num * r.num, den * r.den);
    }

    RationalT opBinary(string op)(/*in*/ RationalT r)
    /*const pure nothrow*/ if (op == "/") {
        return RationalT(num * r.den, den * r.num);
    }

    RationalT opBinary(string op, U)(in U r)
    /*const pure nothrow*/ if (isIntegral!U && (op == "+" ||
                               op == "-" || op == "*" || op == "/")) {
        return opBinary!op(RationalT(r));
    }

    RationalT opBinary(string op)(in size_t p)
    /*const pure nothrow*/ if (op == "^^") {
        return RationalT(num ^^ p, den ^^ p);
    }

    RationalT opBinaryRight(string op, U)(in U l)
    /*const pure nothrow*/ if (isIntegral!U) {
        return RationalT(l).opBinary!op(RationalT(num, den));
    }

    RationalT opOpAssign(string op, U)(/*in*/ U l)
    /*const pure nothrow*/ {
        mixin("this = this " ~ op ~ "l;");
        return this;
    }

    RationalT opUnary(string op)()
    /*const pure nothrow*/ if (op == "+" || op == "-") {
        return RationalT(mixin(op ~ "num"), den);
    }

    bool opCast(U)() const if (is(U == bool)) {
        return num != 0;
    }

    int opEquals(U)(/*in*/ U r) /*const pure nothrow*/ {
        RationalT rhs = RationalT(r);
        if (type() == Type.NaRAT || rhs.type() == Type.NaRAT)
            return false;
        return num == rhs.num && den == rhs.den;
    }

    int opCmp(U)(/*in*/ U r) /*const pure nothrow*/ {
        auto rhs = RationalT(r);
        if (type() == Type.NaRAT || rhs.type() == Type.NaRAT)
            throw new Exception("Compare involve a NaRAT.");
        if (type() != Type.NORMAL ||
            rhs.type() != Type.NORMAL) // for infinite
            return (type() == rhs.type()) ? 0 :
                ((type() < rhs.type()) ? -1 : 1);
        auto diff = num * rhs.den - den * rhs.num;
        return (diff == 0) ? 0 : ((diff < 0) ? -1 : 1);
    }

    Type type() /*const pure nothrow*/ {
        if (den > 0) return Type.NORMAL;
        if (den < 0) return Type.NegDEN;
        if (num > 0) return Type.PosINF;
        if (num < 0) return Type.NegINF;
        return Type.NaRAT;
    }
}

alias Rational = RationalT!BigInt;

version (arithmetic_rational_main) { // Test.
    void main() {
        import std.stdio, std.math;
        alias RatL = RationalT!long;

        foreach (immutable p; 2 .. 2 ^^ 19) {
            auto sum = RatL(1, p);
            immutable limit = 1 + cast(uint)sqrt(cast(real)p);
            foreach (immutable factor; 2 .. limit)
                if (p % factor == 0)
                    sum += RatL(1, factor) + RatL(factor, p);
            if (sum.denominator == 1)
                writefln("Sum of recipr. factors of %6s = %s exactly%s",
                         p, sum, (sum == 1) ? ", perfect." : ".");
        }
    }
}
