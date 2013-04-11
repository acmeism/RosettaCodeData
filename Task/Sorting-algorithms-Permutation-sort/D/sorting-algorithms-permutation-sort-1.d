import std.stdio, std.algorithm, permutations2;

void permutationSort(T)(T[] items) /*pure nothrow*/ {
    foreach (perm; permutations!false(items))
        if (isSorted(perm)) {
            items[] = perm;
            break;
        }
}

void main() {
    auto data = [2, 7, 4, 3, 5, 1, 0, 9, 8, 6, -1];
    permutationSort(data);
    writeln(data);
}
