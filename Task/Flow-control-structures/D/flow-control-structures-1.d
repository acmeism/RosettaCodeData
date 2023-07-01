import std.stdio;

void main() {
    label1:
    writeln("I'm in your infinite loop.");
    goto label1;
}
