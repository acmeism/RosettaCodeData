import std.stdio, std.complex, std.math, std.range, std.algorithm,
       std.numeric, std.exception, std.traits;

// alias CM(T) = Complex!T[][]; // Not yet useful.

auto conjugateTranspose(T)(in Complex!T[][] m) pure nothrow /*@safe*/
if (!hasIndirections!T) {
    return iota(m[0].length).map!(i => m.transversal(i).map!conj.array).array;
}

T[][] matMul(T)(immutable T[][] A, immutable T[][] B) pure nothrow /*@safe*/ {
    immutable Bt = B[0].length.iota.map!(i => B.transversal(i).array).array;
    return A.map!(a => Bt.map!(b => a.dotProduct(b)).array).array;
}

/// Check any number of complex matrices for equality within
/// some bits of mantissa.
bool areEqual(T)(in Complex!T[][][] matrices, in size_t nBits=20)
pure nothrow /*@safe*/ {
    static bool allSame(U)(in U[] v) pure nothrow @nogc @safe {
        return v[1 .. $].all!(c => c == v[0]);
    }

    bool allNearSame(in Complex!T[] v) pure nothrow @nogc @safe {
        auto v0 = v[0].Complex!T; // To avoid another cast.
        return v[1 .. $].all!(c => feqrel(v0.re, c.re) >= nBits &&
                                   feqrel(v0.im, c.im) >= nBits);
    }

    immutable x = matrices.map!(m => m.length).array;
    if (!allSame(x))
        return false;
    immutable y = matrices.map!(m => m[0].length).array;
    if (!allSame(y))
        return false;
    foreach (immutable s; 0 .. x[0])
        foreach (immutable t; 0 .. y[0])
            if (!allNearSame(matrices.map!(m => m[s][t]).array))
                return false;
    return true;
}

bool isHermitian(T)(in Complex!T[][] m, in Complex!T[][] ct)
pure nothrow /*@safe*/ {
    return [m, ct].areEqual;
}

bool isNormal(T)(immutable Complex!T[][] m, immutable Complex!T[][] ct)
pure nothrow /*@safe*/ {
    return [matMul(m, ct), matMul(ct, m)].areEqual;
}

auto complexIdentitymatrix(in size_t side) pure nothrow /*@safe*/ {
    return side.iota.map!(r => side.iota.map!(c => complex(r == c)).array).array;
}

bool isUnitary(T)(immutable Complex!T[][] m, immutable Complex!T[][] ct)
pure nothrow /*@safe*/ {
    immutable mct = matMul(m, ct);
    immutable ident = mct.length.complexIdentitymatrix;
    return [mct, matMul(ct, m), ident].areEqual;
}

void main() {
    alias C = complex;
    immutable x = 2 ^^ 0.5 / 2;

    foreach (/*immutable*/ const matrix;
        [[[C(3.0,  0.0), C(2.0, 1.0)],
          [C(2.0, -1.0), C(1.0, 0.0)]],

         [[C(1.0, 0.0), C(1.0, 0.0), C(0.0, 0.0)],
          [C(0.0, 0.0), C(1.0, 0.0), C(1.0, 0.0)],
          [C(1.0, 0.0), C(0.0, 0.0), C(1.0, 0.0)]],

         [[C(x,    0.0), C(x,   0.0), C(0.0, 0.0)],
          [C(0.0, -x),   C(0.0, x),   C(0.0, 0.0)],
          [C(0.0,  0.0), C(0.0, 0.0), C(0.0, 1.0)]]]) {
        immutable mat = matrix.assumeUnique; //*

        enum mFormat = "[%([%(%1.3f, %)],\n %)]]";
        writefln("Matrix:\n" ~ mFormat, mat);
        immutable ct = conjugateTranspose(mat);
        "Its conjugate transpose:".writeln;
        writefln(mFormat, ct);
        writefln("Hermitian? %s.", isHermitian(mat, ct));
        writefln("Normal?    %s.", isNormal(mat, ct));
        writefln("Unitary?   %s.\n", isUnitary(mat, ct));
    }
}
