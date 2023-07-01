import std.stdio;

string stripchars(string s, string chars) {
    import std.algorithm;
    import std.conv;
    return s.filter!(c => !chars.count(c)).to!string;
}

string stripchars2(string s, string chars) {
    import std.regex;
    return replaceAll(s, regex("[" ~ chars ~ "]"), "");
}

void main() {
    string s = "She was a soul stripper. She took my heart!";
    string chars = "aei";

    writeln(stripchars(s, chars));
    writeln(stripchars2(s, chars));
}
