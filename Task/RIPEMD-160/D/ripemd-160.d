import std.stdio, std.digest.ripemd;

void main() {
    auto txt = "Rosetta Code";
    writeln("%-(%02x%)", txt.ripemd160Of());
}
