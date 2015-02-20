import std.stdio, std.algorithm;

void combSort(T)(T[] input) pure nothrow @safe @nogc {
    int gap = input.length;
    bool swaps = true;

    while (gap > 1 || swaps) {
        gap = max(1, cast(int)(gap / 1.2473));
        swaps = false;
        foreach (immutable i; 0 .. input.length - gap)
            if (input[i] > input[i + gap]) {
                input[i].swap(input[i + gap]);
                swaps = true;
            }
    }
}

void main() {
    auto data = [28, 44, 46, 24, 19, 2, 17, 11, 25, 4];
    data.combSort;
    data.writeln;
}
