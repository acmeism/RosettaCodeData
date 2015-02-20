import std.stdio, std.algorithm, std.array;

/// Return one of the Longest Increasing Subsequence of
/// items using patience sorting.
T[] lis(T)(in T[] items) pure nothrow
if (__traits(compiles, T.init < T.init))
out(result) {
    assert(result.length <= items.length);
    assert(result.isSorted);
    assert(result.all!(x => items.canFind(x)));
} body {
    if (items.empty)
        return null;

    static struct Node { T val; Node* back; }
    auto pile = [[new Node(items[0])]];

    OUTER: foreach (immutable di; items[1 .. $]) {
        foreach (immutable j, ref pj; pile)
            if (pj[$ - 1].val > di) {
                pj ~= new Node(di, j ? pile[j - 1][$ - 1] : null);
                continue OUTER;
            }
        pile ~= [new Node(di, pile[$ - 1][$ - 1])];
    }

    T[] result;
    for (auto ptr = pile[$ - 1][$ - 1]; ptr != null; ptr = ptr.back)
        result ~= ptr.val;
    result.reverse();
    return result;
}

void main() {
    foreach (d; [[3,2,6,4,5,1],
                 [0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15]])
        d.lis.writeln;
}
