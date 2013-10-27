import std.stdio, std.range, std.ascii, std.string, std.algorithm,
       std.conv;

enum mod = (in int m, in int n) pure nothrow => ((m % n) + n) % n;

enum _s2v = (in string s) pure /*nothrow*/ =>
    s.toUpper.removechars("^A-Z").map!q{ a - 'A' };

string _v2s(R)(R v) pure /*nothrow*/ {
    return v.map!(x => uppercase[x.mod(26)]).text;
}

enum encrypt = (in string txt, in string key) pure /*nothrow*/ =>
    txt._s2v.zip(key._s2v.cycle).map!q{ a[0] + a[1] }._v2s;

enum decrypt = (in string txt, in string key) pure /*nothrow*/ =>
    txt._s2v.zip(key._s2v.cycle).map!q{ a[0] - a[1] }._v2s;

void main() {
    immutable key = "Vigenere Cipher!!!";
    immutable original = "Beware the Jabberwock, my son!" ~
                         " The jaws that bite, the claws that catch!";
    immutable encoded = original.encrypt(key);
    writeln(encoded, "\n", encoded.decrypt(key));
}
