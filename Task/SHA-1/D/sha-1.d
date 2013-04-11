import std.stdio, std.digest.sha;

void main() {
    writefln("%-(%02x%)", "Ars longa, vita brevis".sha1Of());
}
