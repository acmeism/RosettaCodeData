import std.stdio;

void showByteLen(T)(T[] str) {
    writefln("Byte length: %2d - %(%02x%)",
             str.length * T.sizeof, cast(ubyte[])str);
}

void main() {
    string s1a = "møøse"; // UTF-8
    showByteLen(s1a);
    wstring s1b = "møøse"; // UTF-16
    showByteLen(s1b);
    dstring s1c = "møøse"; // UTF-32
    showByteLen(s1c);
    writeln();

    string s2a = "𝔘𝔫𝔦𝔠𝔬𝔡𝔢";
    showByteLen(s2a);
    wstring s2b = "𝔘𝔫𝔦𝔠𝔬𝔡𝔢";
    showByteLen(s2b);
    dstring s2c = "𝔘𝔫𝔦𝔠𝔬𝔡𝔢";
    showByteLen(s2c);
    writeln();

    string s3a = "J̲o̲s̲é̲";
    showByteLen(s3a);
    wstring s3b = "J̲o̲s̲é̲";
    showByteLen(s3b);
    dstring s3c = "J̲o̲s̲é̲";
    showByteLen(s3c);
}
