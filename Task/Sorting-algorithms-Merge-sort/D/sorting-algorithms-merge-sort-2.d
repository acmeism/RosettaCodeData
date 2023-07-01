import std.stdio, std.algorithm, core.stdc.stdlib, std.exception,
       std.range;

void mergeSort(T)(T[] data) if (hasSwappableElements!(typeof(data))) {
    immutable L = data.length;
    if (L < 2) return;
    T* ptr = cast(T*)alloca(L * T.sizeof);
    enforce(ptr != null);
    ptr[0 .. L] = data[];
    mergeSort(ptr[0 .. L/2]);
    mergeSort(ptr[L/2 .. L]);
    [ptr[0 .. L/2], ptr[L/2 .. L]].nWayUnion().copy(data);
}

void main() {
    auto a = [3, 4, 2, 5, 1, 6];
    a.mergeSort();
    writeln(a);
}
