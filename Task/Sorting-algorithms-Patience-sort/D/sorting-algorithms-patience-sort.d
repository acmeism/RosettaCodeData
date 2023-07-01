import std.stdio, std.array, std.range, std.algorithm;

void patienceSort(T)(T[] items) /*pure nothrow @safe*/
if (__traits(compiles, T.init < T.init)) {
    //SortedRange!(int[][], q{ a.back < b.back }) piles;
    T[][] piles;

    foreach (x; items) {
        auto p = [x];
        immutable i = piles.length -
                      piles
                      .assumeSorted!q{ a.back < b.back }
                      .upperBound(p)
                      .length;
        if (i != piles.length)
            piles[i] ~= x;
        else
            piles ~= p;
    }

    piles.nWayUnion!q{ a > b }.copy(items.retro);
}

void main() {
    auto data = [4, 65, 2, -31, 0, 99, 83, 782, 1];
    data.patienceSort;
    assert(data.isSorted);
    data.writeln;
}
