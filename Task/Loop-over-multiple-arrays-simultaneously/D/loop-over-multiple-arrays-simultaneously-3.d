import std.stdio, std.range;

void main() {
    auto arr1 = [1, 2, 3, 4, 5];
    auto arr2 = [6, 7, 8, 9, 10];

    foreach (ref a, ref b; lockstep(arr1, arr2))
        a += b;

    assert(arr1 == [7, 9, 11, 13, 15]);

    // Lockstep also supports iteration with an index variable
    foreach (index, a, b; lockstep(arr1, arr2))
        writefln("Index %s:  a = %s, b = %s", index, a, b);
}
