void main() /*@safe*/ {
    import std.array: empty, replace;
    import std.string: representation, assumeUTF;

    // String creation (destruction is usually handled by
    // the garbage collector).
    ubyte[] str1;

    // String assignments.
    str1 = "blah".dup.representation;
    // Hex string, same as "\x00\xFB\xCD\x32\xFD\x0A"
    // whitespace and newlines are ignored.
    str1 = cast(ubyte[])x"00 FBCD 32FD 0A";

    // String comparison.
    ubyte[] str2;
    if (str1 == str2) {} // Strings equal.

    // String cloning and copying.
    str2 = str1.dup; // Copy entire string or array.

    // Check if a string is empty
    if (str1.empty) {} // String empty.
    if (str1.length) {} // String not empty.
    if (!str1.length) {} // String empty.

    // Append a ubyte to a string.
    str1 ~= x"0A";
    str1 ~= 'a';

    // Extract a substring from a string.
    str1 = "blork".dup.representation;
    // This takes off the first and last bytes and
    // assigns them to the new ubyte string.
    // This is just a light slice, no string data copied.
    ubyte[] substr = str1[1 .. $ - 1];

    // Replace every occurrence of a ubyte (or a string)
    // in a string with another string.
    str1 = "blah".dup.representation;
    replace(str1.assumeUTF, "la", "al");

    // Join two strings.
    ubyte[] str3 = str1 ~ str2;
}
