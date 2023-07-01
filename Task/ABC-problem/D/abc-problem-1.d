import std.stdio, std.algorithm, std.string;

bool canMakeWord(in string word, in string[] blocks) pure /*nothrow*/ @safe {
    auto bs = blocks.dup;
    outer: foreach (immutable ch; word.toUpper) {
        foreach (immutable block; bs)
            if (block.canFind(ch)) {
                bs = bs.remove(bs.countUntil(block));
                continue outer;
            }
        return false;
    }
    return true;
}

void main() @safe {
    immutable blocks = "BO XK DQ CP NA GT RE TG QD FS JW HU VI
                        AN OB ER FS LY PC ZM".split;

    foreach (word; "" ~ "A BARK BoOK TrEAT COmMoN SQUAD conFUsE".split)
        writefln(`"%s" %s`, word, canMakeWord(word, blocks));
}
