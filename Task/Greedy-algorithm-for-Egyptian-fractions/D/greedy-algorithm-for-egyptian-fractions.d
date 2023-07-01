import std.stdio, std.bigint, std.algorithm, std.range, std.conv, std.typecons,
       arithmetic_rational: Rat = Rational;

Rat[] egyptian(Rat r) pure nothrow {
    typeof(return) result;

    if (r >= 1) {
        if (r.denominator == 1)
            return [r, Rat(0, 1)];
        result = [Rat(r.numerator / r.denominator, 1)];
        r -= result[0];
    }

    static enum mod = (in BigInt m, in BigInt n) pure nothrow =>
        ((m % n) + n) % n;

    while (r.numerator != 1) {
        immutable q = (r.denominator + r.numerator - 1) / r.numerator;
        result ~= Rat(1, q);
        r = Rat(mod(-r.denominator, r.numerator), r.denominator * q);
    }

    result ~= r;
    return result;
}

void main() {
    foreach (immutable r; [Rat(43, 48), Rat(5, 121), Rat(2014, 59)])
        writefln("%s => %(%s %)", r, r.egyptian);

    Tuple!(size_t, Rat) lenMax;
    Tuple!(BigInt, Rat) denomMax;

    foreach (immutable r; iota(1, 100).cartesianProduct(iota(1, 100))
                          .map!(nd => nd[].Rat).array.sort().uniq) {
        immutable e = r.egyptian;
        immutable eLen = e.length;
        immutable eDenom = e.back.denominator;
        if (eLen > lenMax[0])
            lenMax = tuple(eLen, r);
        if (eDenom > denomMax[0])
            denomMax = tuple(eDenom, r);
    }
    writefln("Term max is %s with %d terms", lenMax[1], lenMax[0]);
    immutable dStr = denomMax[0].text;
    writefln("Denominator max is %s with %d digits %s...%s",
             denomMax[1], dStr.length, dStr[0 .. 5], dStr[$ - 5 .. $]);
}
