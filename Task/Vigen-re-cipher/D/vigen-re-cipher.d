import std.stdio, std.string;

string encrypt(in string txt, in string key) pure
in {
    assert(key.removechars("^A-Z") == key);
} body {
    string res;
    foreach (immutable i, immutable c; toUpper(txt).removechars("^A-Z"))
        res ~= (c + key[i % $] - 2 * 'A') % 26 + 'A';
    return res;
}

string decrypt(in string txt, in string key) pure
in {
    assert(key.removechars("^A-Z") == key);
} body {
    string res;
    foreach (immutable i, immutable c; toUpper(txt).removechars("^A-Z"))
       res ~= (c - key[i % $] + 26) % 26 + 'A';
    return res;
}

void main() {
    immutable key = "VIGENERECIPHER";
    immutable original = "Beware the Jabberwock, my son!" ~
                         " The jaws that bite, the claws that catch!";
    immutable encoded = original.encrypt(key);
    writeln(encoded, "\n", encoded.decrypt(key));
}
