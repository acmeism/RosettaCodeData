void main() @safe {
    import std.stdio, std.range, std.algorithm;

    immutable phrase = "rosetta code phrase reversal";
    phrase.retro.writeln;                          // Reversed string.
    phrase.splitter.map!retro.joiner(" ").writeln; // Words reversed.
    phrase.split.retro.joiner(" ").writeln;        // Word order reversed.
}
