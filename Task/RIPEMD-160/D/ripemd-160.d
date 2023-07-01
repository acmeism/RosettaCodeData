void main() {
    import std.stdio, std.digest.ripemd;

    writefln("%(%02x%)", "Rosetta Code".ripemd160Of);
}
