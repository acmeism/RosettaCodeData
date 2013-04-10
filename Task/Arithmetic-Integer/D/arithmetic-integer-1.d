import std.stdio, std.string, std.conv;

void main() {
    int a = 10, b = 20;
    try {
        a = readln().strip().to!int();
        b = readln().strip().to!int();
    } catch (StdioException e) {}
    writeln("a = ", a, ", b = ", b);

    writeln("a + b = ", a + b);
    writeln("a - b = ", a - b);
    writeln("a * b = ", a * b);
    writeln("a / b = ", a / b);
    writeln("a % b = ", a % b);
    writeln("a ^^ b = ", a ^^ b);
}
