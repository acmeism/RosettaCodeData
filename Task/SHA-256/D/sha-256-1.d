void main() {
    import std.stdio, std.digest.sha;

    writefln("%-(%02x%)", "Rosetta code".sha256Of);
}
