import std.stdio, std.math, std.range, std.conv, std.algorithm;

double f(in double x) pure nothrow {
    return x.abs().sqrt() + 5 * x ^^ 3;
}

void main() {
    double[] data;
    while (true) {
        write("Please enter eleven numbers on a line: ");
        data = readln().split().map!(to!double)().array();
        if (data.length == 11)
            break;
        writeln("Those aren't eleven numbers.");
    }
    foreach (x; data.retro()) {
        immutable y = f(x);
        writefln("f(%0.3f) = %s", x, y > 400 ? "Too large" : text(y));
    }
}
