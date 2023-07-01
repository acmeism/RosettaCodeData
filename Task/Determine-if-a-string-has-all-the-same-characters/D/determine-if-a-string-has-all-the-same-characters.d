import std.stdio;

void analyze(string s) {
    writefln("Examining [%s] which has a length of %d:", s, s.length);
    if (s.length > 1) {
        auto b = s[0];
        foreach (i, c; s[1..$]) {
            if (c != b) {
                writeln("    Not all characters in the string are the same.");
                writefln("    '%c' (0x%x) is different at position %d", c, c, i);
                return;
            }
        }
    }
    writeln("    All characters in the string are the same.");
}

void main() {
    auto strs = ["", "   ", "2", "333", ".55", "tttTTT", "4444 444k"];
    foreach (str; strs) {
        analyze(str);
    }
}
