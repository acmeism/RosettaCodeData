import std.stdio, std.ascii, std.algorithm, std.array;

alias Block = char[2];

// Modifies the order of the given blocks.
bool canMakeWord(Block[] blocks, in string word) pure nothrow
in {
    assert(blocks.all!(w => w[].all!isAlpha));
    assert(word.all!isAlpha);
} body {
    if (word.empty)
        return true;

    immutable c = word[0].toUpper;
    foreach (ref b; blocks) {
        if (b[0].toUpper != c && b[1].toUpper != c)
            continue;
        blocks[0].swap(b);
        if (blocks[1 .. $].canMakeWord(word[1 .. $]))
            return true;
        blocks[0].swap(b);
    }

    return false;
}

void main() {
    enum Block[] blocks = "BO XK DQ CP NA GT RE TG QD FS
                           JW HU VI AN OB ER FS LY PC ZM".split;

    foreach (w; "" ~ "A BARK BoOK TrEAT COmMoN SQUAD conFUsE".split)
        writefln(`"%s" %s`, w, blocks.canMakeWord(w));

    // Extra test.
    Block[] blocks2 = ["AB", "AB", "AC", "AC"];
    immutable word = "abba";
    writefln(`"%s" %s`, word, blocks2.canMakeWord(word));
}
