void main() {
    import std.stdio, std.utf;

    string test = "a";
    size_t index = 0;

    // Get four-byte utf32 value for index 0.
    writefln("%d", test.decode(index));

    // 'index' has moved to next character input position.
    assert(index == 1);
}
