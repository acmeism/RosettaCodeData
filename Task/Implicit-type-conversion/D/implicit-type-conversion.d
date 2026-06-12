void main() {
    import std.stdio, std.typetuple, std.variant, std.complex;

    enum IntEnum : int { A, B }
    union IntFloatUnion { int x; float y; }
    struct IntStruct { int x; }
    class ClassRef {}
    class DerivedClassRef : ClassRef {}
    alias IntDouble = Algebraic!(int, double);
    alias ComplexDouble = Complex!double;

    // On a 64 bit system size_t and ptrdiff_t are twice larger,
    // so this changes few implicit assignments results.
    writeln("On a ", size_t.sizeof * 8, " bit system:\n");

    // Represented as strings so size_t prints as "size_t"
    // instead of uint/ulong.
    alias types = TypeTuple!(
        `IntEnum`, `IntFloatUnion`, `IntStruct`,
        `bool`,
        `char`, `wchar`, `dchar`,
        `ubyte`, `ushort`, `uint`, `ulong`, /*`ucent`,*/
        `byte`, `short`, `int`, `long`, /*`cent`,*/
        `size_t`, `hash_t`, `ptrdiff_t`,
        `float`, `double`, `real`,
        `int[2]`, `int[]`, `int[int]`,
        `int*`, `void*`, `ClassRef`, `DerivedClassRef`,
        `void function()`, `void delegate()`,
        `IntDouble`, `ComplexDouble`,
    );

    foreach (T1; types) {
        mixin(T1 ~ " x;");
        write("A ", T1, " can be assigned with: ");
        foreach (T2; types) {
            mixin(T2 ~ " y;");
            static if (__traits(compiles, x = y))
                write(T2, " ");
        }
        writeln;
    }
    writeln;

    // Represented as strings so 1.0 prints as "1.0" instead of "1."
    alias values = TypeTuple!(
        `true`, `'x'`, `"hello"`, `"hello"w`, `"hello"d`,
        `0`, `255`, `1L`, `2.0f`, `3.0`, `4.0L`, `10_000_000_000L`,
        `[1, 2]`, `[3: 4]`,
        `void*`, `null`,
    );

    foreach (T; types) {
        mixin(T ~ " x;");
        write("A ", T, " can be assigned with value literal(s): ");
        foreach (y; values) {
            static if (__traits(compiles, x = mixin(y)))
                write(y, " ");
        }
        writeln;
    }

    // Few extras:
    int[] a1;
    const int[] a2 = a1;                 // OK.
    // immutable int[] a3 = a1;          // Not allowed.
    // immutable int[] a4 = a2;          // Not allowed.
    int[int] aa1;
    const int[int] aa2 = aa1;            // OK.
    //immutable int[int] aa3 = aa1;      // Not allowed.
    //immutable int[int] aa4 = aa2;      // Not allowed.

    void foo() {}
    void delegate() f1 = &foo;           // OK.
    void bar() pure nothrow @safe {}
    void delegate() f2 = &bar;           // OK.
    //void delegate() pure f3 = &foo;    // Not allowed.
    //void delegate() nothrow f4 = &foo; // Not allowed.
    //void delegate() @safe f5 = &foo;   // Not allowed.

    static void spam() {}
    void function() f6 = &spam;          // OK.
    //void function() f7 = &foo;         // Not allowed.
}
