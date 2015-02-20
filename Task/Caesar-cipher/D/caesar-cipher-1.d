import std.stdio, std.traits;

S rot(S)(in S s, in int key) pure nothrow @safe
if (isSomeString!S) {
    auto res = s.dup;

    foreach (immutable i, ref c; res) {
        if ('a' <= c && c <= 'z')
            c = ((c - 'a' + key) % 26 + 'a');
        else if ('A' <= c && c <= 'Z')
            c = ((c - 'A' + key) % 26 + 'A');
    }
    return res;
}

void main() @safe {
    enum key = 3;
    immutable txt = "The five boxing wizards jump quickly";
    writeln("Original:  ", txt);
    writeln("Encrypted: ", txt.rot(key));
    writeln("Decrypted: ", txt.rot(key).rot(26 - key));
}
