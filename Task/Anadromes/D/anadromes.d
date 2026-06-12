import std.stdio, std.file, std.string, std.range, std.algorithm;

void main() {
    auto words = readText("words.txt").splitLines.filter!"a.length > 6".array.sort;

    foreach (w; words)
        if (w < w.dup.reverse && words.contains(w.dup.reverse))
            writefln("%-12s %-12s", w, w.dup.reverse);
}
