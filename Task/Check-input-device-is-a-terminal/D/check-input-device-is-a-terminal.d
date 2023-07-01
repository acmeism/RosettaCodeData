import std.stdio;

extern(C) int isatty(int);

void main() {
    if (isatty(0))
        writeln("Input comes from tty.");
    else
        writeln("Input doesn't come from tty.");
}
