import std.ascii, core.stdc.stdlib;

bool canMakeWord(in string word, in string[] blocks) nothrow @nogc
in {
    foreach (immutable char ch; word)
        assert(ch.isASCII);
    foreach (const block; blocks)
        assert(block.length == 2 && block[0].isASCII && block[1].isASCII);
} body {
    auto ptr = cast(string*)alloca(blocks.length * string.sizeof);
    if (ptr == null)
        exit(1);
    auto blocks2 = ptr[0 .. blocks.length];
    blocks2[] = blocks[];

    outer: foreach (immutable i; 0 .. word.length) {
        immutable ch = word[i].toUpper;
        foreach (immutable j; 0 .. blocks2.length) {
            if (blocks2[j][0] == ch || blocks2[j][1] == ch) {
                if (blocks2.length > 1)
                    blocks2[j] = blocks2[$ - 1];
                blocks2 = blocks2[0 .. $ - 1];
                continue outer;
            }
        }
        return false;
    }
    return true;
}

void main() {
    import std.stdio, std.string;

    immutable blocks = "BO XK DQ CP NA GT RE TG QD FS JW HU VI
                        AN OB ER FS LY PC ZM".split;

    foreach (word; "" ~ "A BARK BoOK TrEAT COmMoN SQUAD conFUsE".split)
        writefln(`"%s" %s`, word, canMakeWord(word, blocks));
}
