import std.compiler, std.math;

void main() {
    // Compile-time constants of the compiler version:
    static if (version_major < 2 && version_minor > 50) {
        // this prevents further compilation
        static assert(false, "I can't cope with this compiler version");
    } else {
        pragma(msg, "The compiler version is acceptable.");
    }

    immutable bloop = 10;

    // To check if something compiles:
    //static if (__traits(compiles, bloop.abs)) {
    static if (__traits(compiles, abs(bloop))) {
        pragma(msg, "The expression is compilable.");
        auto x = bloop.abs;
    } else {
        pragma(msg, "The expression can't be compiled.");
    }
}
