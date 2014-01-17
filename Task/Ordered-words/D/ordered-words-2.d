void main() {
    import std.stdio, std.algorithm, std.file, std.range;
    string[] result;
    size_t maxWalkLen;

    foreach (word; "unixdict.txt".readText.splitter) {
        if (word.length >= maxWalkLen && word.isSorted) {
            immutable wlen = word.walkLength;
            if (wlen > maxWalkLen) {
                result.length = 0;
                maxWalkLen = wlen;
            }
            result ~= word.idup;
        }
    }

    writefln("%-(%s\n%)", result);
}
