void main() {
    import std.stdio;

    enum width = 512, height = 512;

    auto f = File("xor_pattern.ppm", "wb");
    f.writefln("P6\n%d %d\n255", width, height);
    foreach (immutable y; 0 .. height)
        foreach (immutable x; 0 .. width) {
            immutable c = (x ^ y) & ubyte.max;
            immutable ubyte[3] u3 = [255 - c, c / 2, c];
            f.rawWrite(u3);
        }
}
