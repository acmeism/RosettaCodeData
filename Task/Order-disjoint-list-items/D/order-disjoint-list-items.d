import std.stdio, std.string, std.algorithm, std.array, std.range,
       std.conv;

T[] orderDisjointArrayItems(T)(in T[] data, in T[] items)
pure /*nothrow*/ @safe {
    int[] itemIndices;
    foreach (item; items.dup.sort().uniq) {
        immutable int itemCount = items.count(item);
        assert(data.count(item) >= itemCount,
               text("More of ", item, " than in data"));
        auto lastIndex = [-1];
        foreach (immutable _; 0 .. itemCount) {
            immutable start = lastIndex.back + 1;
            lastIndex ~= data[start .. $].countUntil(item) + start;
        }
        itemIndices ~= lastIndex.dropOne;
    }

    itemIndices.sort();
    auto result = data.dup;
    foreach (index, item; zip(itemIndices, items))
        result[index] = item;
    return result;
}

void main() {
    immutable problems =
   "the cat sat on the mat  | mat cat
    the cat sat on the mat  | cat mat
    A B C A B C A B C       | C A C A
    A B C A B D A B E       | E A D A
    A B                     | B
    A B                     | B A
    A B B A                 | B A
                            |
    A                       | A
    A B                     |
    A B B A                 | A B
    A B A B                 | A B
    A B A B                 | B A B A
    A B C C B A             | A C A C
    A B C C B A             | C A C A"
    .splitLines.map!(r => r.split("|")).array;

    foreach (immutable p; problems) {
        immutable a = p[0].split;
        immutable b = p[1].split;
        writefln("%s | %s -> %-(%s %)", p[0].strip, p[1].strip,
                 orderDisjointArrayItems(a, b));
    }
}
