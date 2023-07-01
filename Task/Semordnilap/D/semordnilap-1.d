void main() {
    import std.stdio, std.file, std.string, std.algorithm;

    bool[string] seenWords;
    size_t pairCount = 0;

    foreach (const word; "unixdict.txt".readText.toLower.splitter) {
        //const drow = word.dup.reverse();
        auto drow = word.dup;
        drow.reverse();
        if (drow in seenWords) {
            if (pairCount++ < 5)
                writeln(word, " ", drow);
        } else
            seenWords[word] = true;
    }

    writeln("\nSemordnilap pairs: ", pairCount);
}
