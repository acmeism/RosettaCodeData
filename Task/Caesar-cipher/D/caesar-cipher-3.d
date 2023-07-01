import std.stdio, std.ascii, std.string, std.algorithm;

string rot(in string s, in int key) pure nothrow @safe {
    auto uppr = uppercase.dup.representation;
    bringToFront(uppr[0 .. key], uppr[key .. $]);
    auto lowr = lowercase.dup.representation;
    bringToFront(lowr[0 .. key], lowr[key .. $]);
    return s.translate(makeTrans(letters, assumeUTF(uppr ~ lowr)));
}

void main() {
    enum key = 3;
    immutable txt = "The five boxing wizards jump quickly";
    writeln("Original:  ", txt);
    writeln("Encrypted: ", txt.rot(key));
    writeln("Decrypted: ", txt.rot(key).rot(26 - key));
}
