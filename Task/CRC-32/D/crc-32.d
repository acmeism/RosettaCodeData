void main() {
    import std.stdio, std.digest.crc;

    "The quick brown fox jumps over the lazy dog"
    .crc32Of.crcHexString.writeln;
}
