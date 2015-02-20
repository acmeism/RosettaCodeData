import std.stdio, std.random, std.algorithm, std.conv, std.range,
       std.traits, std.typecons;

auto bestShuffle(S)(in S orig) @safe if (isSomeString!S) {
    static if (isNarrowString!S)
        immutable o = orig.dtext;
    else
        alias o = orig;

    auto s = o.dup;
    s.randomShuffle;

    foreach (immutable i, ref ci; s) {
        if (ci != o[i])
            continue;
        foreach (immutable j, ref cj; s)
            if (ci != cj && ci != o[j] && cj != o[i]) {
                swap(ci, cj);
                break;
            }
    }

    return tuple(s, s.zip(o).count!q{ a[0] == a[1] });
} unittest {
    assert("abracadabra".bestShuffle[1] == 0);
    assert("immediately".bestShuffle[1] == 0);
    assert("grrrrrr".bestShuffle[1] == 5);
    assert("seesaw".bestShuffle[1] == 0);
    assert("pop".bestShuffle[1] == 1);
    assert("up".bestShuffle[1] == 0);
    assert("a".bestShuffle[1] == 1);
    assert("".bestShuffle[1] == 0);
}

void main(in string[] args) @safe {
    if (args.length > 1) {
        immutable entry = args.dropOne.join(' ');
        const res = entry.bestShuffle;
        writefln("%s : %s (%d)", entry, res[]);
    }
}
