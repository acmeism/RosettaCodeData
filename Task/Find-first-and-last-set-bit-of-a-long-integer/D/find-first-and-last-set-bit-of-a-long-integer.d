import std.stdio, core.bitop, std.bigint;

void main() {
    enum size_t test = 42;
    for (size_t i = 0; true; i++) {
        immutable size_t x = test ^^ i;
        if (x != BigInt(test) ^^ i)
            break;
        writefln("%18d %0*b MSB: %2d LSB: %2d",
                 x, size_t.sizeof * 8, x, bsr(x), bsf(x));
    }
}
