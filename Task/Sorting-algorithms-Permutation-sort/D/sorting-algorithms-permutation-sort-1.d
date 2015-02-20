import std.stdio, std.algorithm, permutations2;

void permutationSort(T)(T[] items) pure nothrow @safe @nogc {
    foreach (const perm; items.permutations!false)
        if (perm.isSorted)
            break;
}

void main() {
    auto data = [2, 7, 4, 3, 5, 1, 0, 9, 8, 6, -1];
    data.permutationSort;
    data.writeln;
}
