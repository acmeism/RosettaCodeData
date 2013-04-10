import std.stdio, std.digest.crc;

void main() {
    "The quick brown fox jumps over the lazy dog"
    .crc32Of().crcHexString().writeln();
}
