import core.stdc.stdio, core.stdc.stdlib;

extern(C) void foo() nothrow {
    "foo at exit".puts;
}

extern(C) void bar() nothrow {
    "bar at exit".puts;
}

extern(C) void spam() nothrow {
    "spam at exit".puts;
}

int baz(in int x) pure nothrow
in {
    assert(x != 0);
} body {
    if (x < 0)
        return 10;
    if (x > 0)
        return 20;

    // x can't be 0.

    // In release mode this becomes a halt, and it's sometimes
    // necessary. If you remove this the compiler gives:
    // Error: function test.notInfinite no return exp;
    //    or assert(0); at end of function
    assert(false);
}

// This generates an error, that is not meant to be caught.
// Objects are not guaranteed to be finalized.
int empty() pure nothrow {
    throw new Error(null);
}

static ~this() {
    // This module destructor is never called if
    // the program calls the exit function.
    import std.stdio;
    "Never called".writeln;
}

void main() {
    atexit(&foo);
    atexit(&bar);
    atexit(&spam);

    //abort(); // Also this is allowed. Will not call foo, bar, spam.
    exit(0);
}
