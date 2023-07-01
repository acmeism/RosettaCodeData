import std.stdio, std.ascii;

void inplaceRot(char[] txt, in int key) pure nothrow {
    foreach (ref c; txt) {
        if (isLower(c))
            c = (c - 'a' + key) % 26 + 'a';
        else if (isUpper(c))
            c = (c - 'A' + key) % 26 + 'A';
    }
}

void main() {
    enum key = 3;
    auto txt = "The five boxing wizards jump quickly".dup;
    writeln("Original:  ", txt);
    txt.inplaceRot(key);
    writeln("Encrypted: ", txt);
    txt.inplaceRot(26 - key);
    writeln("Decrypted: ", txt);
}
