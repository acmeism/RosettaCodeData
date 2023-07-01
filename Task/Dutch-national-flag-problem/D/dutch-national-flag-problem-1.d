import std.stdio, std.random, std.algorithm, std.traits, std.array;

enum DutchColors { red, white, blue }

void dutchNationalFlagSort(DutchColors[] items) pure nothrow @nogc {
    int lo, mid, hi = items.length - 1;

    while (mid <= hi)
        final switch (items[mid]) {
            case DutchColors.red:
                swap(items[lo++], items[mid++]);
                break;
            case DutchColors.white:
                mid++;
                break;
            case DutchColors.blue:
                swap(items[mid], items[hi--]);
                break;
        }
}

void main() {
    DutchColors[12] balls;
    foreach (ref ball; balls)
        ball = uniform!DutchColors;

    writeln("Original Ball order:\n", balls);
    balls.dutchNationalFlagSort;
    writeln("\nSorted Ball Order:\n", balls);
    assert(balls[].isSorted, "Balls not sorted.");
}
