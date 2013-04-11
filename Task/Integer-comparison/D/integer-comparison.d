import std.stdio, std.conv, std.string;

void main() {
    int a = 10, b = 20;
    try {
        a = to!int(readln().strip());
        b = to!int(readln().strip());
    } catch (StdioException) {}

    if (a < b)
        writeln(a, " is less than ", b);

    if (a == b)
        writeln(a, " is equal to ", b);

    if (a > b)
        writeln(a, " is greater than ", b);
}
