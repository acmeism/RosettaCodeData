import std.stdio, std.string;

string quibbler(in string[] seq) pure /*nothrow*/ {
    if (seq.length <= 1)
        return format("{%-(%s, %)}", seq);
    else
        return format("{%-(%s, %) and %s}", seq[0 .. $-1], seq[$-1]);
}

void main() {
    //foreach (immutable test; [[],
    foreach (const test; [[],
                          ["ABC"],
                          ["ABC", "DEF"],
                          ["ABC", "DEF", "G", "H"]])
        test.quibbler.writeln;
}
