import std.stdio, std.algorithm, std.array, std.range;

T[] mergeSorted(T)(in T[] D) /*pure nothrow @safe*/ {
    if (D.length < 2)
        return D.dup;
    return [D[0 .. $ / 2].mergeSorted, D[$ / 2 .. $].mergeSorted]
           .nWayUnion.array;
}

void main() {
    [3, 4, 2, 5, 1, 6].mergeSorted.writeln;
}
