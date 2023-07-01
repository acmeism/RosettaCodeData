import std.stdio, std.random, std.algorithm, std.range,
       std.array, std.traits;

/*
This implementation has less requirements, it works with just
a Bidirectional Range instead of a Random Access Range.

(Comments modified from "Notes on Programming" by Alexander
 Stepanov.)

  Let us assume that somehow we managed to solve the problem up
  to some middle point s:

  0000001111?????22222222
        ^   ^   ^
        f   s   l         (first, second, last)

  If s points to an item with value 0 (red) we swap it with an
  element pointed at by f and advance both f and s.
  If s refers to an item 1 (white) we just advance s.
  If s refers to an item 2 (blue) we swap elements
  pointed by l and s and we decrement l.

In D/Phobos we use Ranges, that are like pairs of iterators.
So 'secondLast' represents the s and l iterators, and the 'first'
range contains f plus an unused end.

secondLast represents the inclusive range of items not yet seen.
When it's empty, the algorithm has finished.

Loop variant: in each iteration of the for loop the length of
secondLast decreases by 1. So the algorithm terminates.
*/
void dutchNationalFlagSort(Range, T)(Range secondLast,
                                     in T lowVal, in T highVal)
pure nothrow if (isBidirectionalRange!Range &&
                 hasSwappableElements!Range &&
                 is(ElementType!Range == T)) {
    for (auto first = secondLast; !secondLast.empty; )
        if (secondLast.front == lowVal) {
            swap(first.front, secondLast.front);
            first.popFront();
            secondLast.popFront();
        } else if (secondLast.front == highVal) {
            swap(secondLast.front, secondLast.back);
            secondLast.popBack();
        } else
            secondLast.popFront();
}

void main() {
    enum DutchColors { red, white, blue }
    DutchColors[12] balls;
    foreach (ref ball; balls)
        ball = [EnumMembers!DutchColors][uniform(0, $)];

    writeln("Original Ball order:\n", balls);
    balls[].dutchNationalFlagSort(DutchColors.red,
                                  DutchColors.blue);
    writeln("\nSorted Ball Order:\n", balls);
    assert(balls[].isSorted(), "Balls not sorted");

    // More tests:
    foreach (i; 0 .. 100_000) {
        int n = uniform(0, balls.length);
        foreach (ref ball; balls[0 .. n])
            ball = [EnumMembers!DutchColors][uniform(0, $)];
        balls[0 .. n].dutchNationalFlagSort(DutchColors.red,
                                            DutchColors.blue);
        assert(balls[0 .. n].isSorted());
    }
}
