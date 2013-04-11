import std.stdio;

T enGray(T)(in T n) pure nothrow {
    return n ^ (n >>> 1);
}

T deGray(T)(in T n) pure nothrow {
    enum T MSB = (cast(T)1) << (T.sizeof * 8 - 1);

    auto res = (n & MSB) ;
    foreach (bit; 1 .. T.sizeof * 8)
        res += (n ^ (res >>> 1)) & (MSB >>> bit);
    return res;
}

void main() {
    writeln("num  bits    encoded  decoded");
    foreach (i; 0 .. 32) {
        immutable encoded = enGray(i);
        writefln("%2d: %5b ==> %5b : %2d",
                 i, i, encoded, deGray(encoded));
    }
}
