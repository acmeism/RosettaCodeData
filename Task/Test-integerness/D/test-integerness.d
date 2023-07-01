import std.complex;
import std.math;
import std.meta;
import std.stdio;
import std.traits;

void main() {
    print(25.000000);
    print(24.999999);
    print(24.999999, 0.00001);
    print(25.000100);
    print(-2.1e120);
    print(-5e-2);
    print(real.nan);
    print(real.infinity);
    print(5.0+0.0i);
    print(5-5i);
}

void print(T)(T v, real tol = 0.0) {
    writefln("Is %0.10s an integer? %s", v, isInteger(v, tol));
}

/// Test for plain integers
bool isInteger(T)(T v)
if (isIntegral!T) {
    return true;
}

unittest {
    assert(isInteger(5));
    assert(isInteger(-5));

    assert(isInteger(2L));
    assert(isInteger(-2L));
}

/// Test for floating point
bool isInteger(T)(T v, real tol = 0.0)
if (isFloatingPoint!T) {
    return (v - floor(v)) <= tol || (ceil(v) - v) <= tol;
}

unittest {
    assert(isInteger(25.000000));

    assert(!isInteger(24.999999));
    assert(isInteger(24.999999, 0.00001));
}

/// Test for complex numbers
bool isInteger(T)(Complex!T v, real tol = 0.0) {
    return isInteger(v.re, tol) && abs(v.im) <= tol;
}

unittest {
    assert(isInteger(complex(1.0)));
    assert(!isInteger(complex(1.0, 0.0001)));

    assert(isInteger(complex(1.0, 0.00009), 0.0001));
}

/// Test for built-in complex types
bool isInteger(T)(T v, real tol = 0.0)
if (staticIndexOf!(Unqual!T, AliasSeq!(cfloat, cdouble, creal)) >= 0) {
    return isInteger(v.re, tol) && abs(v.im) <= tol;
}

unittest {
    assert(isInteger(1.0 + 0.0i));
    assert(!isInteger(1.0 + 0.0001i));

    assert(isInteger(1.0 + 0.00009i, 0.0001));
}

/// Test for built-in imaginary types
bool isInteger(T)(T v, real tol = 0.0)
if (staticIndexOf!(Unqual!T, AliasSeq!(ifloat, idouble, ireal)) >= 0) {
    return abs(v) <= tol;
}

unittest {
    assert(isInteger(0.0i));
    assert(!isInteger(0.0001i));

    assert(isInteger(0.00009i, 0.0001));
}
