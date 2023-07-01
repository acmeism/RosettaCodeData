import std.bigint;
import std.conv;
import std.exception;
import std.range;
import std.regex;
import std.stdio;

//Taken from the task http://rosettacode.org/wiki/Commatizing_numbers#D
auto commatize(in char[] txt, in uint start=0, in uint step=3, in string ins=",") @safe
in {
    assert(step > 0);
} body {
    if (start > txt.length || step > txt.length)    {
        return txt;
    }

    // First number may begin with digit or decimal point. Exponents ignored.
    enum decFloField = ctRegex!("[0-9]*\\.[0-9]+|[0-9]+");

    auto matchDec = matchFirst(txt[start .. $], decFloField);
    if (!matchDec) {
        return txt;
    }

    // Within a decimal float field:
    // A decimal integer field to commatize is positive and not after a point.
    enum decIntField = ctRegex!("(?<=\\.)|[1-9][0-9]*");
    // A decimal fractional field is preceded by a point, and is only digits.
    enum decFracField = ctRegex!("(?<=\\.)[0-9]+");

    return txt[0 .. start] ~ matchDec.pre ~ matchDec.hit
        .replace!(m => m.hit.retro.chunks(step).join(ins).retro)(decIntField)
        .replace!(m => m.hit.chunks(step).join(ins))(decFracField)
        ~ matchDec.post;
}

auto commatize(BigInt v) {
    return commatize(v.to!string);
}

BigInt sqrt(BigInt x) {
    enforce(x >= 0);

    auto q = BigInt(1);
    while (q <= x) {
        q <<= 2;
    }
    auto z = x;
    auto r = BigInt(0);
    while (q > 1) {
        q >>= 2;
        auto t = z;
        t -= r;
        t -= q;
        r >>= 1;
        if (t >= 0) {
            z = t;
            r += q;
        }
    }
    return r;
}

void main() {
    writeln("The integer square root of integers from 0 to 65 are:");
    foreach (i; 0..66) {
        write(sqrt(BigInt(i)), ' ');
    }
    writeln;

    writeln("The integer square roots of powers of 7 from 7^1 up to 7^73 are:");
    writeln("power                                    7 ^ power                                                 integer square root");
    writeln("----- --------------------------------------------------------------------------------- -----------------------------------------");
    auto pow7 = BigInt(7);
    immutable bi49 = BigInt(49);
    for (int i = 1; i <= 73; i += 2) {
        writefln("%2d %84s %41s", i, pow7.commatize, sqrt(pow7).commatize);
        pow7 *= bi49;
    }
}
