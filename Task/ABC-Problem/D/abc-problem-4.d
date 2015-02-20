import std.stdio, std.ascii, std.algorithm, std.array, std.range;

alias Block = char[2];

bool canMakeWord(immutable Block[] blocks, in string word) pure nothrow
in {
    assert(blocks.all!(w => w[].all!isAlpha));
    assert(word.all!isAlpha);
} body {
    bool inner(size_t[] indexes, in string w) pure nothrow {
        if (w.empty)
            return true;

        immutable c = w[0].toUpper;
        foreach (ref idx; indexes) {
            if (blocks[idx][0].toUpper != c &&
                blocks[idx][1].toUpper != c)
                continue;
            indexes[0].swap(idx);
            if (inner(indexes[1 .. $], w[1 .. $]))
                return true;
            indexes[0].swap(idx);
        }

        return false;
    }

    return inner(blocks.length.iota.array, word);
}

void main() {
    enum Block[] blocks = "BO XK DQ CP NA GT RE TG QD FS
                           JW HU VI AN OB ER FS LY PC ZM".split;

    foreach (w; "" ~ "A BARK BoOK TrEAT COmMoN SQUAD conFUsE".split)
        writefln(`"%s" %s`, w, blocks.canMakeWord(w));

    // Extra test.
    immutable Block[] blocks2 = ["AB", "AB", "AC", "AC"];
    immutable word = "abba";
    writefln(`"%s" %s`, word, blocks2.canMakeWord(word));
}
