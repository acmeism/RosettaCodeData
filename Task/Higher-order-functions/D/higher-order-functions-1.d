int hof(int a, int b, int delegate(int, int) f) {
    return f(a, b);
}

void main() {
    import std.stdio;
    writeln("Add: ", hof(2, 3, (a, b) => a + b));
    writeln("Multiply: ", hof(2, 3, (a, b) => a * b));
}
