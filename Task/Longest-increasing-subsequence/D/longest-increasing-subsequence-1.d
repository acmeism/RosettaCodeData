import std.stdio, std.algorithm, power_set2;

T[] lis(T)(T[] items) pure nothrow {
    //return items.powerSet.filter!isSorted.max!q{ a.length };
    return items
           .powerSet
           .filter!isSorted
           .minPos!q{ a.length > b.length }
           .front;
}

void main() {
    [3, 2, 6, 4, 5, 1].lis.writeln;
    [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15].lis.writeln;
}
