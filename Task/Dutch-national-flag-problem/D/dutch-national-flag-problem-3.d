import std.stdio, std.random, std.algorithm, std.traits, std.range;

enum Color : ubyte { blue, white, red }

immutable isMonochrome = (in Color[] a, in size_t i, in size_t j, in Color c)
    pure nothrow @safe @nogc => iota(i, j).all!(k => a[k] == c);

bool isPermutation(in Color[] a1, in Color[] a2) pure nothrow @safe @nogc {
    size_t[EnumMembers!Color.length] counts1, counts2;
    foreach (immutable x; a1)
        counts1[x]++;
    foreach (immutable x; a2)
        counts2[x]++;
    return counts1 == counts2;
}


void dutchNationalFlagSort(Color[] a) pure nothrow @safe @nogc
    // This function is not @nogc in -debug builds.
    /*
    Scan of the array 'a' from left to right using 'i' and we
    maintain this invariant, using indices 'b' and 'r':

    0         b          i           r
    +---------+----------+-----------+-------+
    |  blue   |  white   |     ?     |  red  |
    +---------+----------+-----------+-------+
    */
out {
    // Find b and r.
    immutable bRaw = a.countUntil!q{a != b}(Color.blue);
    immutable size_t b = (bRaw == -1) ? a.length : bRaw;
    immutable rRaw = a.retro.countUntil!q{a != b}(Color.red);
    immutable size_t r = (rRaw == -1) ? 0 : (a.length - rRaw);

    assert(isMonochrome(a, 0, b, Color.blue));
    assert(isMonochrome(a, b, r, Color.white));
    assert(isMonochrome(a, r, a.length, Color.red));
    // debug assert(isPermutation(a, a.old));
} body {
    size_t b = 0, i = 0, r = a.length;
    debug {
        /*ghost*/ immutable aInit = a.idup; // For loop invariant.
        /*ghost*/ size_t riPred = r - i;    // For loop variant.
    }

    while (i < r) {
        /*invariant*/ assert(0 <= b && b <= i && i <= r && r <= a.length);
        /*invariant*/ assert(isMonochrome(a, 0, b, Color.blue));
        /*invariant*/ assert(isMonochrome(a, b, i, Color.white));
        /*invariant*/ assert(isMonochrome(a, r, a.length, Color.red));
        /*invariant*/ debug assert(isPermutation(a, aInit));

        final switch (a[i]) with (Color) {
            case blue:
                a[b].swap(a[i]);
                b++;
                i++;
                break;
            case white:
                i++;
                break;
            case red:
                r--;
                a[r].swap(a[i]);
                break;
        }

        debug {
            /*variant*/ assert((r - i) < riPred);
            riPred = r - i;
        }
    }
}

void main() {
    Color[12] balls;

    // Test special cases.
    foreach (immutable color; [EnumMembers!Color]) {
        balls[] = color;
        balls.dutchNationalFlagSort;
        assert(balls[].isSorted, "Balls not sorted.");
    }

    foreach (ref b; balls)
        b = uniform!Color;

    writeln("Original Ball order:\n", balls);
    balls.dutchNationalFlagSort;
    writeln("\nSorted Ball Order:\n", balls);
    assert(balls[].isSorted, "Balls not sorted.");
}
