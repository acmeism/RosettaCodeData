import std.stdio, std.file, std.string, std.algorithm,
       std.typecons, std.range;

auto findDeranged(in string[] words) /*pure nothrow*/ {
    Tuple!(string, string)[] result;
    foreach (immutable i, const w1; words)
        foreach (const w2; words[i + 1 .. $])
            if (zip(w1, w2).all!q{ a[0] != a[1] }())
                result ~= tuple(w1, w2);
    return result;
}

void main() {
    Appender!(string[])[30] wClasses;
    foreach (word; std.algorithm.splitter(readText("unixdict.txt")))
        wClasses[$ - word.length] ~= word;
    auto r = wClasses[].map!q{ a.data }().filter!q{ a.length }();
    writeln("Longest deranged anagrams:");
    foreach (words; r) {
        string[][const ubyte[]] anags; // Assume input is ASCII.
        foreach (w; words)
            anags[(cast(ubyte[])w).sort().release().idup] ~= w.idup;
        auto pairs = anags.byValue.filter!q{ a.length > 1 }()
                     .map!findDeranged().filter!q{ a.length }();
        if (!pairs.empty)
            return writefln("  %s, %s", pairs.front[0].tupleof);
    }
}
