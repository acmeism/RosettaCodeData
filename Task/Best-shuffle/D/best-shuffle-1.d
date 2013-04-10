import std.stdio, std.random, std.algorithm, std.conv, std.range,
std.traits, std.typecons;

auto bestShuffle(S)(in S orig) if (isSomeString!S) {
    static if (isNarrowString!S)
        auto o = to!dstring(orig);
    else alias orig o;

    auto s = o.dup;
    randomShuffle(s);
    foreach (i, ref ci; s) {
        if (ci != o[i])
            continue;
        foreach (j, ref cj; s)
            if (ci != cj && ci != o[j] && cj != o[i]) {
                swap(ci, cj);
                break;
            }
    }
    return tuple(s, count!"a[0] == a[1]"(zip(s, o)));
}

unittest {
    assert(bestShuffle("abracadabra"d)[1] == 0);
    assert(bestShuffle("immediately"d)[1] == 0);
    assert(bestShuffle("grrrrrr"d)[1] == 5);
    assert(bestShuffle("seesaw"d)[1] == 0);
    assert(bestShuffle("pop"d)[1] == 1);
    assert(bestShuffle("up"d)[1] == 0);
    assert(bestShuffle("a"d)[1] == 1);
    assert(bestShuffle(""d)[1] == 0);
}

void main(string[] args) {
    if (args.length > 1) {
        string entry = join(args[1 .. $], " ");
        auto res = bestShuffle(entry);
        writefln("%s : %s (%s)", entry, res[0], res[1]);
    }
}
