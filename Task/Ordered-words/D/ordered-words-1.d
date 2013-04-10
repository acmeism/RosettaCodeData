import std.stdio, std.algorithm, std.range, std.string;

void main() {
    string[] result;
    size_t maxLen;

    foreach (string word; File("unixdict.txt").lines()) {
        word = word.chomp();
        immutable len = walkLength(word);
        if (len < maxLen || !isSorted(word))
            continue;
        if (len > maxLen) {
            result = [word];
            maxLen = len;
        } else
            result ~= word;
    }

    writeln(result.join("\n"));
}
