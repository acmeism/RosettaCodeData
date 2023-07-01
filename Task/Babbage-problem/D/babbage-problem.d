// It's basically the same as any other version.
// What can be observed is that 269696 is even, so we have to consider only even numbers,
// because only the square of even numbers is even.

import std.math;
import std.stdio;

void main( )
{
    // get smallest number <= sqrt(269696)
    int k = cast(int)(sqrt(269696.0));

    // if root is odd -> make it even
    if (k % 2 == 1)
        k = k - 1;

    // cycle through numbers
    while ((k * k) % 1000000 != 269696)
        k = k + 2;

    // display output
    writefln("%d * %d = %d", k, k, k*k);
}
