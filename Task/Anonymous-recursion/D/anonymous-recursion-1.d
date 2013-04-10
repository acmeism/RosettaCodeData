uint fib(in uint n) pure nothrow {
    immutable self = &__traits(parent, {});
    return (n < 2) ? n : self(n - 1) + self(n - 2);
}

void main() {
    import std.stdio;
    writeln(fib(39));
}
