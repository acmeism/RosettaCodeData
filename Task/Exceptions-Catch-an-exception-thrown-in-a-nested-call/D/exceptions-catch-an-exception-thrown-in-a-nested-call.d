import std.stdio;

class U0 : Exception {
    this() nothrow { super("U0 error message"); }
}

class U1 : Exception {
    this() nothrow { super("U1 error message"); }
}

void foo(in int i) pure {
    if (i)
        throw new U1;
    else
        throw new U0;
}

void bar(in int i) pure {
    foo(i);
}

void baz() {
    foreach (i; 0 .. 2) {
        try {
            bar(i);
        } catch (U0 e) {
            writeln("Exception U0 caught");
        }
    }
}

void main() {
    baz();
}
