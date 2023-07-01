import std.algorithm;

string wrap(in string text, in int lineWidth) {
    auto words = text.splitter;
    if (words.empty) return null;
    string wrapped = words.front;
    words.popFront();
    int spaceLeft = lineWidth - wrapped.length;
    foreach (word; words)
        if (word.length + 1 > spaceLeft) {
            wrapped ~= "\n" ~ word;
            spaceLeft = lineWidth - word.length;
        } else {
            wrapped ~= " " ~ word;
            spaceLeft -= 1 + word.length;
        }
    return wrapped;
}

void main() {
    immutable frog =
"In olden times when wishing still helped one, there lived a king
whose daughters were all beautiful, but the youngest was so beautiful
that the sun itself, which has seen so much, was astonished whenever
it shone in her face.  Close by the king's castle lay a great dark
forest, and under an old lime-tree in the forest was a well, and when
the day was very warm, the king's child went out into the forest and
sat down by the side of the cool fountain, and when she was bored she
took a golden ball, and threw it up on high and caught it, and this
ball was her favorite plaything.";

    import std.stdio;
    foreach (width; [72, 80])
        writefln("Wrapped at %d:\n%s\n", width, frog.wrap(width));
}
