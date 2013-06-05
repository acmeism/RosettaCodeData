import std.stdio, std.algorithm, std.range, std.string, std.exception;

void main() {
    string[][const ubyte[]] an;
    foreach (w; "unixdict.txt".File.byLine(KeepTerminator.no))
        an[w.dup.representation.sort().release.assumeUnique] ~= w.idup;
    immutable m = an.byValue.map!q{ a.length }.reduce!max;
    writefln("%(%s\n%)", an.byValue.filter!(ws => ws.length == m));
}
