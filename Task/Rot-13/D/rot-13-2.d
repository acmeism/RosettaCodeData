import std.stdio, std.string, std.traits;

pure S rot13(S)(in S s) if (isSomeString!S) {
    return rot(s, 13);
}

pure S rot(S)(in S s, in int key) if (isSomeString!S) {
    auto r = s.dup;

    foreach (i, ref c; r) {
        if ('a' <= c && c <= 'z')
            c = ((c - 'a' + key) % 26 + 'a');
        else if ('A' <= c && c <= 'Z')
            c = ((c - 'A' + key) % 26 + 'A');
    }
    return cast(S) r;
}

void main() {
    "Gur Dhvpx Oebja Sbk Whzcf Bire Gur Ynml Qbt!".rot13().writeln();
}
