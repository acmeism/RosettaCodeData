int test(in int a, in int b) pure nothrow @nogc {
    /*
    mov EAX, [ESP+4]
    add EAX, [ESP+8]
    ret
    */
    immutable ubyte[9] code = [0x8B, 0x44, 0x24, 0x4, 0x3, 0x44, 0x24, 0x8, 0xC3];
    alias F = extern(C) int function(int, int) pure nothrow @nogc;
    immutable f = cast(F)code.ptr;
    return f(a, b); // Run code.
}

void main() {
    import std.stdio;

    test(7, 12).writeln;
}
