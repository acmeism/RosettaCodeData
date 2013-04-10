import std.stdio, std.traits;

pure S rot(S)(in S s, in int key) if (isSomeString!S) {
    auto res = s.dup;

    foreach (i, ref c; res) {
        if ('a' <= c && c <= 'z')
            c = ((c - 'a' + key) % 26 + 'a');
        else if ('A' <= c && c <= 'Z')
            c = ((c - 'A' + key) % 26 + 'A');
    }
    return cast(S) res;
}

void main() {
    int key = 3;
    auto txt = "The five boxing wizards jump quickly";
    writeln("Original:  ", txt);
    writeln("Encrypted: ", txt.rot(key));
    writeln("Decrypted: ", txt.rot(key).rot(26 - key));
}
