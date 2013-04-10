// Compile this module without -O

import std.stdio: writeln, writefln;
import std.string: format;
import std.math: NaN, getNaNPayload;

void show(T)() {
    static string toHex(T x) {
        string result;
        ubyte* ptr = cast(ubyte*)&x;
        foreach (i; 0 .. T.sizeof)
            result = format("%02x", ptr[i]) ~ result;
        return result;
    }

    enum string name =  T.stringof;
    writeln("Computed extreme ", name, " values:");

    T zero     = 0.0;
    T pos_inf  = (cast(T)1.0) / zero;
    writeln(" ", name, " +oo = ", pos_inf);

    T neg_inf  = -pos_inf;
    writeln(" ", name, " -oo = ", neg_inf);

    T pos_zero = (cast(T)1.0) / pos_inf;
    writeln(" ", name, " +0 (pos_zero) = ", pos_zero);

    T neg_zero = (cast(T)1.0) / neg_inf;
    writeln(" ", name, " -0 = ", neg_zero);

    T nan      = zero / pos_zero;
    writefln(" " ~ name ~ " zero / pos_zero = %f  %s", nan, toHex(nan));
    writeln();

    writeln("Some ", T.stringof, " properties and literals:");
    writeln(" ", name, " +oo = ", T.infinity);
    writeln(" ", name, " -oo = ", -T.infinity);
    writeln(" ", name, " +0 = ", (cast(T)0.0));
    writeln(" ", name, " -0 = ", (cast(T)-0.0));
    writefln(" " ~ name ~ " nan = %f   %s", T.nan, toHex(T.nan));
    writefln(" " ~ name ~ " init = %f  %s", T.init, toHex(T.init));
    writeln(" ", name, " epsilon = ", T.epsilon);
    writeln(" ", name, " max = ", T.max);
    writeln(" ", name, " -max = ", -T.max);
    writeln(" ", name, " min_normal = ", -T.min_normal);
    writeln("-----------------------------");
}

void main() {
    show!float();
    show!double();
    show!real();

    writeln("Largest possible payload for float, double and real NaNs:");
    float f1 = NaN(0x3F_FFFF);
    writeln(getNaNPayload(f1));

    double f2 = NaN(0x3_FFFF_FFFF_FFFF);
    writeln(getNaNPayload(f2));

    real f3 = NaN(0x3FFF_FFFF_FFFF_FFFF);
    writeln(getNaNPayload(f3));
}
