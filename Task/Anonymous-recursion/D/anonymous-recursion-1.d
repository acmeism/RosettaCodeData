int fib(in uint arg) pure nothrow @safe @nogc {
    assert(arg >= 0);

    return function uint(in uint n) pure nothrow @safe @nogc {
        static immutable self = &__traits(parent, {});
        return (n < 2) ? n : self(n - 1) + self(n - 2);
    }(arg);
}

void main() {
    import std.stdio;

    39.fib.writeln;
}
