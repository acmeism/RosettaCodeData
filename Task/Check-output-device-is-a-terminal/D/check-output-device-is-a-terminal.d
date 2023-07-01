import std.stdio;

extern(C) int isatty(int);

void main() {
    writeln("Stdout is tty: ", stdout.fileno.isatty == 1);
}
