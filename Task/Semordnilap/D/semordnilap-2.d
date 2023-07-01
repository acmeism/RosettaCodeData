void main() {
    import std.stdio, std.file, std.algorithm, std.string, std.range;

    auto words = "unixdict.txt".readText.split.zip(0.repeat).assocArray;
    auto pairs = zip(words.byKey, words.byKey.map!(w => w.dup.reverse))
                 .filter!(wr => wr[0] < wr[1] && wr[1] in words)
                 .zip(0.repeat).assocArray;
    writeln(pairs.length, "\n", pairs.byKey.take(5));
}
