import std.stdio, std.array;

// Recursive
bool binarySearch(T)(in T[] data, in T item) pure nothrow {
    if (data.empty)
        return false;
    immutable i = data.length / 2;
    immutable mid = data[i];
    if (mid > item)
        return binarySearch(data[0 .. i], item);
    if (mid < item)
        return binarySearch(data[i+1 .. $], item);
    return true;
}

// Iterative
bool binarySearchIt(T)(const(T)[] data, in T item) pure nothrow {
    while (!data.empty) {
        immutable i = data.length / 2;
        immutable mid = data[i];
        if (mid > item)
            data = data[0 .. i];
        else if (mid < item)
            data = data[i+1 .. $];
        else
            return true;
    }
    return false;
}

void main() {
    immutable items = [2, 4, 6, 8, 9];
    foreach (x; [1, 8, 10, 9, 5, 2])
        writefln("%2d %5s %5s", x, binarySearch(items, x),
                 binarySearchIt(items, x));
}
