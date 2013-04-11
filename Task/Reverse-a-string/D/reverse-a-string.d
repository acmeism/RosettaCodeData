import std.stdio, std.range, std.conv;

void main() {
    string s1 = "hello"; // UTF-8
    string s1r = text(retro("hello"));
    assert(s1r == "olleh");

    wstring s2 = "hello"w; // UTF-16
    wstring s2r = wtext(retro("hello"));
    assert(s2r == "olleh");

    dstring s3 = "hello"d; // UTF-32
    dstring s3r = dtext(retro("hello"));
    assert(s3r == "olleh");
}
