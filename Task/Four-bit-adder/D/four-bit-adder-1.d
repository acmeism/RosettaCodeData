import std.stdio, std.traits;

void fourBitsAdder(T)(in T a0, in T a1, in T a2, in T a3,
                      in T b0, in T b1, in T b2, in T b3,
                      out T o0, out T o1,
                      out T o2, out T o3,
                      out T overflow) pure nothrow @nogc {

    // A XOR using only NOT, AND and OR, as task requires.
    static T xor(in T x, in T y) pure nothrow @nogc {
        return (~x & y) | (x & ~y);
    }

    static void halfAdder(in T a, in T b,
                          out T s, out T c) pure nothrow @nogc {
        s = xor(a, b);
        // s = a ^ b; // The built-in D xor.
        c = a & b;
    }

    static void fullAdder(in T a, in T b, in T ic,
                          out T s, out T oc) pure nothrow @nogc {
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

void main() {
    alias T = size_t;
    static assert(isUnsigned!T);

    enum T one = T.max,
           zero = T.min,
           a0 = zero, a1 = one, a2 = zero, a3 = zero,
           b0 = zero, b1 = one, b2 = one,  b3 = one;
    T s0, s1, s2, s3, overflow;

    fourBitsAdder(/*in*/ a0, a1, a2, a3,
                  /*in*/ b0, b1, b2, b3,
                  /*out*/s0, s1, s2, s3, overflow);

    writefln("      a3 %032b", a3);
    writefln("      a2 %032b", a2);
    writefln("      a1 %032b", a1);
    writefln("      a0 %032b", a0);
    writefln("      +");
    writefln("      b3 %032b", b3);
    writefln("      b2 %032b", b2);
    writefln("      b1 %032b", b1);
    writefln("      b0 %032b", b0);
    writefln("      =");
    writefln("      s3 %032b", s3);
    writefln("      s2 %032b", s2);
    writefln("      s1 %032b", s1);
    writefln("      s0 %032b", s0);
    writefln("overflow %032b", overflow);
}
