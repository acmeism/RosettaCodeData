import std.stdio, std.file, std.algorithm, std.string, std.array,
       std.functional, std.exception;

string[2][] findDeranged(in string[] words) pure nothrow {
    // return words.pairwise.filter!(ww => ww[].equal!q{ a != b });
    typeof(return) result;
    foreach (immutable i, w1; words)
        foreach (w2; words[i + 1 .. $])
            if (w1.representation.equal!q{ a != b }(w2.representation))
                result ~= [w1, w2];
    return result;
}

void main() {
    Appender!(string[])[30] wClasses;
    foreach (const w; "unixdict.txt".readText.splitter)
        wClasses[$ - w.length] ~= w;

    foreach (const ws; wClasses[].map!q{ a.data }.filter!(not!empty)) {
        string[][const ubyte[]] anags; // Assume ASCII input.
        foreach (immutable w; ws)
            anags[w.dup.representation.sort().release.assumeUnique]~= w;
        auto pairs = anags.byValue.map!findDeranged.joiner;
        if (!pairs.empty)
            return writefln("Longest deranged: %-(%s %)", pairs.front);
    }
}
