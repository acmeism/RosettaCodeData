import std.stdio, std.algorithm, std.array, std.traits;

template AreSortableArrayItems(T) {
    enum AreSortableArrayItems = isMutable!T &&
                                 __traits(compiles, T.init < T.init) &&
                                 !isNarrowString!(T[]);
}

void selectionSort(T)(T[] data) if (AreSortableArrayItems!T) {
    foreach (i, ref d; data)
        d.swap(data[i .. $].minPos().front);
} unittest {
    int[] a0;
    selectionSort(a0);

    auto a1 = [1];
    selectionSort(a1);
    assert(a1 == [1]);

    auto a2 = ["a", "b"];
    selectionSort(a2);
    assert(a2 == ["a", "b"]);

    auto a3 = ["b", "a"];
    selectionSort(a3);
    assert(a3 == ["a", "b"]);

    auto a4 = ['a', 'b'];
    static assert(!__traits(compiles, selectionSort(a4)));

    dchar[] a5 = ['b', 'a'];
    selectionSort(a5);
    assert(a5 == "ab"d);

    import std.typecons;
    alias Nullable!int N;
    auto a6 = [N(2), N(1)];
    selectionSort(a6); // Not nothrow.
    assert(a6 == [N(1), N(2)]);

    auto a7 = [1.0+0i, 2.0+0i]; // To be deprecated.
    static assert(!__traits(compiles, selectionSort(a7)));

    import std.complex;
    auto a8 = [complex(1), complex(2)];
    static assert(!__traits(compiles, selectionSort(a8)));

    static struct F {
        int x;
        int opCmp(F f) { // Not pure.
            return x < f.x ? -1 : (x > f.x ? 1 : 0);
        }
    }
    auto a9 = [F(2), F(1)];
    selectionSort(a9);
    assert(a9 == [F(1), F(2)]);
}

void main() {
    auto a = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2];
    a.selectionSort();
    writeln(a);
}
