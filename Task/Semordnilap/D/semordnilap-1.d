import std.stdio, std.file, std.string, std.algorithm;

void main() {
    bool[string] seenWords;
    size_t pairCount = 0;

    foreach (const word; readText("unixdict.txt").toLower.splitter) {
        const drow = word.dup.reverse; // Deprecated.
        if (drow in seenWords) {
            if (pairCount++ < 5)
                writeln(word, " ", drow);
        } else
            seenWords[word] = true;
    }

    writeln("\nSemordnilap pairs: ", pairCount);
}
