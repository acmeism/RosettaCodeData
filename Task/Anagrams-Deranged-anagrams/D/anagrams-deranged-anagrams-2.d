import std.stdio, std.file, std.algorithm, std.string, std.range,
       std.functional, std.exception;

string[2][] findDeranged(string[] words) pure /*nothrow*/ {
    //return words.pairwise.filter!(ww=> ww[].zip.all!q{a[0] != a[1]});
    typeof(return) result;
    foreach (immutable i, w1; words)
        foreach (w2; words[i + 1 .. $])
            if (zip(w1, w2).all!q{ a[0] != a[1] })
                result ~= [w1, w2];
    return result;
}

void main() {
    Appender!(string[])[30] wClasses;
    //foreach (word; "unixdict.txt".readText.splitter)
    foreach (word; std.algorithm.splitter("unixdict.txt".readText))
        wClasses[$ - word.length] ~= word;

    "Longest deranged anagrams:".writeln;
    foreach (words; wClasses[].map!q{ a.data }.filter!(not!empty)) {
        string[][const ubyte[]] anags; // Assume ASCII input.
        foreach (w; words)
            anags[w.dup.representation.sort().release.assumeUnique]~= w;
        auto pairs = anags.byValue.map!findDeranged.joiner;
        if (!pairs.empty)
            return writefln("  %-(%s %)", pairs.front);
    }
}
