import std.stdio, std.algorithm, std.string, std.exception, std.file;

void main() {
    string[][ubyte[]] an;
    foreach (w; "unixdict.txt".readText.splitLines)
        an[w.dup.representation.sort().release.assumeUnique] ~= w;
    immutable m = an.byValue.map!q{ a.length }.reduce!max;
    writefln("%(%s\n%)", an.byValue.filter!(ws => ws.length == m));
}
