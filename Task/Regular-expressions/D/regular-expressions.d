import std.stdio, std.regex;

void main() {
    immutable string s = "I am a string";

    // Test:
    if (!match(s, r"string$").empty)
        writeln("Ends with 'string'.");

    // Substitute:
    replace(s, regex(" a "), " another ").writeln();
}
