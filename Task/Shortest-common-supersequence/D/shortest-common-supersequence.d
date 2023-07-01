import std.stdio, std.functional, std.array, std.range;

dstring scs(in dstring x, in dstring y) nothrow @safe {
    alias mScs = memoize!scs;
    if (x.empty) return y;
    if (y.empty) return x;
    if (x.front == y.front)
        return x.front ~ mScs(x.dropOne, y.dropOne);
    if (mScs(x, y.dropOne).length <= mScs(x.dropOne, y).length)
        return y.front ~ mScs(x, y.dropOne);
    else
        return x.front ~ mScs(x.dropOne, y);
}

void main() @safe {
    scs("abcbdab", "bdcaba").writeln;
}
