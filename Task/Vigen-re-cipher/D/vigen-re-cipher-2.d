import std.stdio, std.range, std.ascii, std.string, std.algorithm,
       std.conv;

immutable mod = (in int m, in int n) pure nothrow @safe @nogc =>
    ((m % n) + n) % n;

immutable _s2v = (in string s) pure /*nothrow*/ @safe =>
    s.toUpper.removechars("^A-Z").map!q{ a - 'A' };

string _v2s(R)(R v) pure /*nothrow*/ @safe {
    return v.map!(x => uppercase[x.mod(26)]).text;
}

immutable encrypt = (in string txt, in string key) pure /*nothrow*/ @safe =>
    txt._s2v.zip(key._s2v.cycle).map!q{ a[0] + a[1] }._v2s;

immutable decrypt = (in string txt, in string key) pure /*nothrow*/ @safe =>
    txt._s2v.zip(key._s2v.cycle).map!q{ a[0] - a[1] }._v2s;

void main() {
    immutable key = "Vigenere Cipher!!!";
    immutable original = "Beware the Jabberwock, my son!" ~
                         " The jaws that bite, the claws that catch!";
    immutable encoded = original.encrypt(key);
    writeln(encoded, "\n", encoded.decrypt(key));
}
