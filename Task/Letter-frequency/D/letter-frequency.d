import std.stdio, std.ascii, std.algorithm, std.range;

void main() {
    int[26] frequency;

    foreach (ubyte[] buffer; File("unixdict.txt").byChunk(2 ^^ 15))
        foreach (c; buffer.filter!isAlpha())
            frequency[c.toLower() - 'a']++;

    writefln("%(%(%s, %),\n%)", std.range.chunks(frequency[], 10));
}
