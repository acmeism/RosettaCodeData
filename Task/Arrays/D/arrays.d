// All D arrays are capable of bounds checks.

import std.stdio, core.stdc.stdlib;
import std.container: Array;

void main() {
    // GC-managed heap allocated dynamic array:
    auto array1 = new int[1];
    array1[0] = 1;
    array1 ~= 3; // append a second item
    // array1[10] = 4; // run-time error
    writeln("A) Element 0: ", array1[0]);
    writeln("A) Element 1: ", array1[1]);

    // Stack-allocated fixed-size array:
    int[5] array2;
    array2[0] = 1;
    array2[1] = 3;
    // array2[2] = 4; // compile-time error
    writeln("B) Element 0: ", array2[0]);
    writeln("B) Element 1: ", array2[1]);

    // Stack-allocated dynamic fixed-sized array,
    // length known only at run-time:
    int n = 2;
    int[] array3 = (cast(int*)alloca(n * int.sizeof))[0 .. n];
    array3[0] = 1;
    array3[1] = 3;
    // array3[10] = 4; // run-time error
    writeln("C) Element 0: ", array3[0]);
    writeln("C) Element 1: ", array3[1]);

    // Phobos-defined  heap allocated not GC-managed array:
    Array!int array4;
    array4.length = 2;
    array4[0] = 1;
    array4[1] = 3;
    // array4[10] = 4; // run-time exception
    writeln("D) Element 0: ", array4[0]);
    writeln("D) Element 1: ", array4[1]);
}
