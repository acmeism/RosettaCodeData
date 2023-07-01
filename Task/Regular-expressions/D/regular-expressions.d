void main() {
    import std.stdio, std.regex;

    immutable s = "I am a string";

    // Test.
    if (s.match("string$"))
        "Ends with 'string'.".writeln;

    // Substitute.
    s.replace(" a ".regex, " another ").writeln;
}
