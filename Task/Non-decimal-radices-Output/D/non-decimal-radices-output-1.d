import std.stdio;

void main() {
    writeln("Base: 2      8     10     16");
    writeln("----------------------------");
    foreach (i; 0 .. 34)
        writefln(" %6b %6o %6d %6x", i, i, i, i);
}
