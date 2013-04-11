import std.stdio, std.conv, std.string, std.algorithm;

string extractRanges(in int[] items)
in {
    assert(items.isSorted());
} body {
    string[] ranges;

    for (size_t i = 0; i < items.length; i++) {
        immutable low = items[i];
        while (i < (items.length - 1) && (items[i] + 1) == items[i + 1])
            i++;
        immutable hi = items[i];

        if (hi - low >= 2)
            ranges ~= text(low, '-', hi);
        else if (hi - low == 1)
            ranges ~= text(low, ',', hi);
        else
            ranges ~= text(low);
    }

    return ranges.join(",");
}

void main() {
    foreach (data; [[-8, -7, -6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9,
                     10, 11, 14, 15, 17, 18, 19, 20],
                    [0, 0, 0, 1, 1],
                    [0, 1, 2, 4, 6, 7, 8, 11, 12, 14, 15, 16, 17, 18,
                     19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31,
                     32, 33, 35, 36, 37, 38, 39]])
        writeln(extractRanges(data));
}
