void main() {
    import std.stdio, std.file, std.algorithm, std.string, std.range,
           std.functional, std.exception;

    string[][const ubyte[]] anags;
    foreach (const w; "unixdict.txt".readText.split)
        anags[w.dup.representation.sort().release.assumeUnique] ~= w;

    anags
    .byValue
    .map!(words => cartesianProduct(words, words)
                   .filter!(ww => ww[].equal!q{ a != b })
                   .array)
    .filter!(not!empty)
    .array
    .schwartzSort!q{ a[0][0].length }
    .back[0]
    .writeln;
}
