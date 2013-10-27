import std.stdio, std.exception;

int fib(int arg) pure {
    enforce(arg >= 0);

    return function int (int n) pure nothrow {
        auto self = __traits(parent, {});
        return (n < 2) ? n : self(n - 1) + self(n - 2);
    }(arg);
}

void main() {
    39.fib.writeln;
}
