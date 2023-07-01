import std.stdio, std.range, std.conv;

void showCodePointsLen(T)(T[] str) {
    writefln("Character length: %2d - %(%x %)",
             str.walkLength(), cast(uint[])to!(dchar[])(str));
}

void main() {
    string s1a = "møøse"; // UTF-8
    showCodePointsLen(s1a);
    wstring s1b = "møøse"; // UTF-16
    showCodePointsLen(s1b);
    dstring s1c = "møøse"; // UTF-32
    showCodePointsLen(s1c);
    writeln();

    string s2a = "𝔘𝔫𝔦𝔠𝔬𝔡𝔢";
    showCodePointsLen(s2a);
    wstring s2b = "𝔘𝔫𝔦𝔠𝔬𝔡𝔢";
    showCodePointsLen(s2b);
    dstring s2c = "𝔘𝔫𝔦𝔠𝔬𝔡𝔢";
    showCodePointsLen(s2c);
    writeln();

    string s3a = "J̲o̲s̲é̲";
    showCodePointsLen(s3a);
    wstring s3b = "J̲o̲s̲é̲";
    showCodePointsLen(s3b);
    dstring s3c = "J̲o̲s̲é̲";
    showCodePointsLen(s3c);
}
