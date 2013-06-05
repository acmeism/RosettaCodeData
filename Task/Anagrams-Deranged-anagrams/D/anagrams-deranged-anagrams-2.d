import std.stdio, std.file, std.algorithm, std.string,
       std.typecons, std.range, std.functional;

auto findDeranged(in string[] words) pure /*nothrow*/ {
    //return words.pairwise.filter!(ww=> ww[].zip.all!q{a[0] != a[1]});
    Tuple!(string, string)[] result;
    foreach (immutable i, const w1; words)
        foreach (const w2; words[i + 1 .. $])
            if (zip(w1, w2).all!q{ a[0] != a[1] })
                result ~= tuple(w1, w2);
    return result;
}

void main() {
    Appender!(string[])[30] wClasses;
    foreach (word; std.algorithm.splitter("unixdict.txt".readText))
        wClasses[$ - word.length] ~= word;

    "Longest deranged anagrams:".writeln;
    foreach (words; wClasses[].map!q{ a.data }.filter!(not!empty)) {
        string[][const ubyte[]] anags; // Assume ASCII input.
        foreach (w; words)
            anags[w.dup.representation.sort().release.idup] ~= w;
        auto pairs = anags.byValue.map!findDeranged.join;
        if (!pairs.empty)
            return writefln("  %s, %s", pairs.front[]);
    }
}
