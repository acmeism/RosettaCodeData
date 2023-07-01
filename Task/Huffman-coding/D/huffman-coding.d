import std.stdio, std.algorithm, std.typecons, std.container, std.array;

auto encode(alias eq, R)(Group!(eq, R) sf) /*pure nothrow @safe*/ {
    auto heap = sf.map!(s => tuple(s[1], [tuple(s[0], "")]))
                .array.heapify!q{b < a};

    while (heap.length > 1) {
        auto lo = heap.front; heap.removeFront;
        auto hi = heap.front; heap.removeFront;
        lo[1].each!((ref pair) => pair[1] = '0' ~ pair[1]);
        hi[1].each!((ref pair) => pair[1] = '1' ~ pair[1]);
        heap.insert(tuple(lo[0] + hi[0], lo[1] ~ hi[1]));
    }
    return heap.front[1].schwartzSort!q{ tuple(a[1].length, a[0]) };
}

void main() /*@safe*/ {
    immutable s = "this is an example for huffman encoding"d;
    foreach (const p; s.dup.sort().group.encode)
        writefln("'%s'  %s", p[]);
}
