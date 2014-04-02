void main() {
    import std.stdio, std.file, std.algorithm, std.string, std.array;

    string[][dstring] anags;
    foreach (const w; "unixdict.txt".readText.split)
        anags[w.array.sort().release.idup] ~= w;

    anags
    .byValue
    .map!(words => words.cartesianProduct(words)
                   .filter!q{ a[].equal!q{ a != b }})
    .join
    .minPos!q{ a[0].length > b[0].length }[0]
    .writeln;
}
