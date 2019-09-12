void main() {
    import std.stdio, std.digest.sha;

    writefln("%-(%02x%)", "Ars longa, vita brevis".sha1Of);
}
