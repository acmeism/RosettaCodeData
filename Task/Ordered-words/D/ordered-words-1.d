void main() {
    import std.stdio, std.algorithm, std.range, std.string;

    string[] result;
    size_t maxLen;

    foreach (string word; "unixdict.txt".File.lines) {
        word = word.chomp;
        immutable len = word.walkLength;
        if (len < maxLen || !word.isSorted)
            continue;
        if (len > maxLen) {
            result = [word];
            maxLen = len;
        } else
            result ~= word;
    }

    writefln("%-(%s\n%)", result);
}
