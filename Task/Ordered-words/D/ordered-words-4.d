import std.stdio, core.stdc.string, std.mmfile, std.algorithm;

const(char)[] findWord(const char[] s) pure nothrow @safe @nogc {
    size_t wordEnd = 0;
    while (wordEnd < s.length && s[wordEnd] != '\n' && s[wordEnd] != '\r')
        wordEnd++;
    return s[0 .. wordEnd];
}

void main() {
    auto mmf = new MmFile("unixdict.txt", MmFile.Mode.readCopyOnWrite, 0, null);
    auto txt = cast(char[])(mmf[]);
    size_t maxLen = 0, outStart = 0;

    for (size_t wordStart = 0; wordStart < txt.length; ) {
        while (wordStart < txt.length &&
               (txt[wordStart] == '\r' || txt[wordStart] == '\n'))
            wordStart++;
        const word = findWord(txt[wordStart .. $]);
        wordStart += word.length;

        if (word.length < maxLen || !word.isSorted)
            continue;
        if (word.length > maxLen) {
            // Longer ordered word found, reset the out buffer.
            outStart = 0;
            maxLen = word.length;
        }

        // Use the same mmap'd region to store output. Because of
        // Mode.readCopyOnWrite, change will not go back to file.
        // We are using  only the head space to store output, so
        // kernel doesn't need to copy more than the words we saved,
        // in this case, one page tops.
        memcpy(&txt[outStart], word.ptr, word.length);
        outStart += word.length;
        txt[outStart++] = '\n'; // Words separator in out buffer.
    }

    txt[0 .. outStart].write;
}
