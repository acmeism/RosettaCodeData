import std.stdio;

void main() {
    int delegate()[] funcs;

    foreach (i; 0 .. 10)
        funcs ~= (i => () => i ^^ 2)(i);

    writeln(funcs[3]());
}
