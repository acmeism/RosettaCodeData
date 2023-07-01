import std.stdio;

int fib(in int n) pure nothrow {
    assert(n >= 0);

    return (new class {
        static int opCall(in int m) pure nothrow {
            if (m < 2)
                return m;
            else
                return opCall(m - 1) + opCall(m - 2);
        }
    })(n);
}

void main() {
    writeln(fib(39));
}
