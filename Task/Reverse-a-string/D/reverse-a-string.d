void main() {
    import std.stdio, std.range, std.conv;

    string s1 = "hello"; // UTF-8
    assert(s1.retro.text == "olleh");

    wstring s2 = "hello"w; // UTF-16
    assert(s2.retro.wtext == "olleh");

    dstring s3 = "hello"d; // UTF-32
    assert(s3.retro.dtext == "olleh");
}
