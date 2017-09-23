import std.stdio, std.string, std.conv, std.meta;

void main() {
    int a = -16, b = 5;
    try {
        a = readln().strip().to!int();
        b = readln().strip().to!int();
    } catch (StdioException e) {}
    writeln("a = ", a, ", b = ", b);

    foreach (op; AliasSeq!("+", "-", "*", "/", "%", "^^"))
        mixin(`writeln("a ` ~ op ~ ` b = ", a` ~ op ~ `b);`);
}
