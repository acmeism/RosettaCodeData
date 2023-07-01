void repeat(void function() fun, in uint times) {
    foreach (immutable _; 0 .. times)
        fun();
}

void procedure() {
    import std.stdio;
    "Example".writeln;
}

void main() {
    repeat(&procedure, 3);
}
