void main() {
    import std.stdio, std.algorithm, std.file, std.string;

    auto keys = "unixdict.txt".readText!(char[]);
    immutable vals = keys.idup;
    string[][string] anags;
    foreach (w; keys.splitter) {
        immutable k = w.representation.sort().release.assumeUTF;
        anags[k] ~= vals[k.ptr - keys.ptr .. k.ptr - keys.ptr + k.length];
    }
    //immutable m = anags.byValue.maxs!q{ a.length };
    immutable m = anags.byValue.map!q{ a.length }.reduce!max;
    writefln("%(%-(%s %)\n%)", anags.byValue.filter!(ws => ws.length == m));
}
