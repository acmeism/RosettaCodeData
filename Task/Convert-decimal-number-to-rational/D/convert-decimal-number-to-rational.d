import std.stdio, std.math, std.string, std.typecons;

alias Fraction = Tuple!(int,"nominator", uint,"denominator");

Fraction real2Rational(in real r, in uint bound) /*pure*/ nothrow {
    if (r == 0.0) {
        return Fraction(0, 1);
    } else if (r < 0.0) {
        auto result = real2Rational(-r, bound);
        result.nominator = -result.nominator;
        return result;
    } else {
        uint best = 1;
        real bestError = real.max;

        foreach (i; 1 .. bound + 1) {
            // round is not pure.
            immutable real error = abs(i * r - round(i * r));
            if (error < bestError) {
                best = i;
                bestError = error;
            }
        }

        return Fraction(cast(int)round(best * r), best);
    }
}

void main() {
    immutable tests = [ 0.750000000,  0.518518000, 0.905405400,
                        0.142857143,  3.141592654, 2.718281828,
                       -0.423310825, 31.415926536];

    foreach (r; tests) {
        writef("%8.9f  ", r);
        foreach (i; 0 .. 5)
            writef("  %d/%d", real2Rational(r, 10 ^^ i).tupleof);
        writeln();
    }
}
