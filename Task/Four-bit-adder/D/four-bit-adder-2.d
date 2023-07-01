import std.stdio, std.traits, core.simd;

void fourBitsAdder(T)(in T a0, in T a1, in T a2, in T a3,
                      in T b0, in T b1, in T b2, in T b3,
                      out T o0, out T o1,
                      out T o2, out T o3,
                      out T overflow) pure nothrow {

    // A XOR using only NOT, AND and OR, as task requires.
    static T xor(in T x, in T y) pure nothrow {
        return (~x & y) | (x & ~y);
    }

    static void halfAdder(in T a, in T b,
                          out T s, out T c) pure nothrow {
        s = xor(a, b);
        // s = a ^ b; // The built-in D xor.
        c = a & b;
    }

    static void fullAdder(in T a, in T b, in T ic,
                          out T s, out T oc) pure nothrow {
        T ps, pc, tc;

        halfAdder(/*in*/a, b,   /*out*/ps, pc);
        halfAdder(/*in*/ps, ic, /*out*/s, tc);
        oc = tc | pc;
    }

    T zero, tc0, tc1, tc2;

    fullAdder(/*in*/a0, b0, zero, /*out*/o0, tc0);
    fullAdder(/*in*/a1, b1, tc0,  /*out*/o1, tc1);
    fullAdder(/*in*/a2, b2, tc1,  /*out*/o2, tc2);
    fullAdder(/*in*/a3, b3, tc2,  /*out*/o3, overflow);
}

int main() {
    alias T = ubyte16; // ubyte32 with AVX.
    immutable T zero;
    immutable T one = ubyte.max;
    immutable T a0 = zero, a1 = one, a2 = zero, a3 = zero,
                b0 = zero, b1 = one, b2 = one,  b3 = one;
    T s0, s1, s2, s3, overflow;

    fourBitsAdder(/*in*/ a0, a1, a2, a3,
                  /*in*/ b0, b1, b2, b3,
                  /*out*/s0, s1, s2, s3, overflow);

    //writefln("      a3 %(%08b%)", a3);
    writefln("      a3 %(%08b%)", a3.array);
    writefln("      a2 %(%08b%)", a2.array);
    writefln("      a1 %(%08b%)", a1.array);
    writefln("      a0 %(%08b%)", a0.array);
    writefln("      +");
    writefln("      b3 %(%08b%)", b3.array);
    writefln("      b2 %(%08b%)", b2.array);
    writefln("      b1 %(%08b%)", b1.array);
    writefln("      b0 %(%08b%)", b0.array);
    writefln("      =");
    writefln("      s3 %(%08b%)", s3.array);
    writefln("      s2 %(%08b%)", s2.array);
    writefln("      s1 %(%08b%)", s1.array);
    writefln("      s0 %(%08b%)", s0.array);
    writefln("overflow %(%08b%)", overflow.array);
}
