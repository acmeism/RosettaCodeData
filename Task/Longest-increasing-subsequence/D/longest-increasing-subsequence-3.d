import std.stdio, std.algorithm, std.range, std.array;

T[] lis(T)(in T[] items) pure nothrow
if (__traits(compiles, T.init < T.init))
out(result) {
    assert(result.length <= items.length);
    assert(result.isSorted);
    assert(result.all!(x => items.canFind(x)));
} body {
    if (items.empty)
        return null;

    static struct Node {
        T value;
        Node* pointer;
    }
    Node*[] pileTops;
    auto nodes = minimallyInitializedArray!(Node[])(items.length);

    // Sort into piles.
    foreach (idx, x; items) {
        auto node = &nodes[idx];
        node.value = x;
        immutable i = pileTops.length -
                      pileTops.assumeSorted!q{a.value < b.value}
                      .upperBound(node)
                      .length;
        if (i != 0)
            node.pointer = pileTops[i - 1];
        if (i != pileTops.length)
            pileTops[i] = node;
        else
            pileTops ~= node;
    }

    // Extract LIS from nodes.
    size_t count = 0;
    for (auto n = pileTops[$ - 1]; n != null; n = n.pointer)
        count++;
    auto result = minimallyInitializedArray!(T[])(count);
    for (auto n = pileTops[$ - 1]; n != null; n = n.pointer)
        result[--count] = n.value;
    return result;
}

void main() {
    foreach (d; [[3,2,6,4,5,1],
                 [0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15]])
        d.writeln;
}
