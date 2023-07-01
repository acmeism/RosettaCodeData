import std.stdio, core.simd;

void main() {
    // Stack-allocated vector for SIMD registers:
    ubyte16 vector5;
    vector5.array[0] = 1;
    vector5.array[1] = 3;
    // vector5.array[17] = 4; // Compile-time error.
    writeln("E) Element 0: ", vector5.array[0]);
    writeln("E) Element 1: ", vector5.array[1]);
}
