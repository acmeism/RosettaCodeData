void main() {
    import std.stdio;

    foreach (immutable i; 0 .. 16)
        writefln("%b", i);
}
