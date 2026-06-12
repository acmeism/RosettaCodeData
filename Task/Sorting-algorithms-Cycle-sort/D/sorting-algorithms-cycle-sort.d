import std.stdio, std.algorithm;

/// Sort an array in place and return the number of writes.
uint cycleSort(T)(T[] data) pure nothrow @safe @nogc {
    typeof(return) nWrites = 0;

    // Loop through the data to find cycles to rotate.
    foreach (immutable cycleStart, item1; data) {
        // Find where to put the item1.
        size_t pos = cycleStart;
        foreach (item2; data[cycleStart + 1 .. $])
            if (item2 < item1)
                pos++;

        // If the item1 is already there, this is not a cycle.
        if (pos == cycleStart)
            continue;

        // Otherwise, put the item1 there or right after any duplicates.
        while (item1 == data[pos])
            pos++;
        data[pos].swap(item1);
        nWrites++;

        // Rotate the rest of the cycle.
        while (pos != cycleStart) {
            // Find where to put the item1.
            pos = cycleStart;
            foreach (item2; data[cycleStart + 1 .. $])
                if (item2 < item1)
                    pos++;

            // Put the item1 there or right after any duplicates.
            while (item1 == data[pos])
                pos++;
            data[pos].swap(item1);
            nWrites++;
        }
    }

    return nWrites;
}

void main() {
    immutable x = [0, 1, 2, 2, 2, 2, 1, 9, 3.5, 5, 8, 4, 7, 0, 6];
    auto xs = x.dup;
    immutable nWrites = xs.cycleSort;

    if (!xs.isSorted) {
        "Wrong order!".writeln;
    } else {
        writeln(x, "\nIs correctly sorted using cycleSort to:");
        writefln("%s\nusing %d writes.", xs, nWrites);
    }
}
