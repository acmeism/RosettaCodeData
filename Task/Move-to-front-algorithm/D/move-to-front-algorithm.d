import std.stdio, std.string, std.ascii, std.algorithm;

ptrdiff_t[] mtfEncoder(in string data) pure nothrow @safe
in {
    assert(data.countchars("a-z") == data.length);
} out(result) {
    assert(result.length == data.length);
    assert(result.all!(e => e >= 0 && e < lowercase.length));
} body {
    ubyte[lowercase.length] order = lowercase.representation;
    auto encoded = new typeof(return)(data.length);

    size_t i = 0;
    foreach (immutable b; data) {
        immutable j = encoded[i++] = order[].countUntil(b);
        bringToFront(order[0 .. j], order[j .. j + 1]);
    }

    return encoded;
}

string mtfDecoder(in ptrdiff_t[] encoded) pure nothrow @safe
in {
    assert(encoded.all!(e => e >= 0 && e < lowercase.length));
} out(result) {
    assert(result.length == encoded.length);
    assert(result.countchars("a-z") == result.length);
} body {
    ubyte[lowercase.length] order = lowercase.representation;
    auto decoded = new char[encoded.length];

    size_t i = 0;
    foreach (immutable code; encoded) {
        decoded[i++] = order[code];
        bringToFront(order[0 .. code], order[code .. code + 1]);
    }

    return decoded;
}

void main() {
    foreach (immutable word; ["broood", "bananaaa", "hiphophiphop"]) {
        immutable encoded = word.mtfEncoder;
        immutable decoded = encoded.mtfDecoder;
        writefln("'%s' encodes to %s, which decodes back to '%s'",
                 word, encoded, decoded);
        assert(word == decoded);
    }
}
