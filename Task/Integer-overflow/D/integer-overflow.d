void main() @safe {
    import std.stdio;

    writeln("Signed 32-bit:");
    writeln(-(-2_147_483_647 - 1));
    writeln(2_000_000_000 + 2_000_000_000);
    writeln(-2147483647 - 2147483647);
    writeln(46_341 * 46_341);
    writeln((-2_147_483_647 - 1) / -1);

    writeln("\nSigned 64-bit:");
    writeln(-(-9_223_372_036_854_775_807 - 1));
    writeln(5_000_000_000_000_000_000 + 5_000_000_000_000_000_000);
    writeln(-9_223_372_036_854_775_807 - 9_223_372_036_854_775_807);
    writeln(3_037_000_500 * 3_037_000_500);
    writeln((-9_223_372_036_854_775_807 - 1) / -1);

    writeln("\nUnsigned 32-bit:");
    writeln(-4_294_967_295U);
    writeln(3_000_000_000U + 3_000_000_000U);
    writeln(2_147_483_647U - 4_294_967_295U);
    writeln(65_537U * 65_537U);

    writeln("\nUnsigned 64-bit:");
    writeln(-18_446_744_073_709_551_615UL);
    writeln(10_000_000_000_000_000_000UL + 10_000_000_000_000_000_000UL);
    writeln(9_223_372_036_854_775_807UL - 18_446_744_073_709_551_615UL);
    writeln(4_294_967_296UL * 4_294_967_296UL);

    import core.checkedint;
    bool overflow = false;
    // Checked signed multiplication.
    // Eventually such functions will be recognized by D compilers
    // and they will be implemented with efficient intrinsics.
    immutable r = muls(46_341, 46_341, overflow);
    writeln("\n", r, " ", overflow);
}
