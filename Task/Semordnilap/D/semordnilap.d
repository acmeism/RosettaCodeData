import std.stdio, std.file, std.string, std.algorithm;

void main() {
    bool[string] seenWords;
    size_t pairCount = 0;

    foreach (word; readText("unixdict.txt").toLower().splitter()) {
        auto drow = word.dup.reverse;
        if (drow in seenWords) {
            if (pairCount++ < 5)
                writeln(word, " ", drow);
        } else
            seenWords[word] = true;
    }

    writeln("\nSemordnilap pairs: ", pairCount);
}
