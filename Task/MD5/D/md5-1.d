void main() {
    import std.stdio, std.digest.md;

    auto txt = "The quick brown fox jumped over the lazy dog's back";
    writefln("%-(%02x%)", txt.md5Of);
}
