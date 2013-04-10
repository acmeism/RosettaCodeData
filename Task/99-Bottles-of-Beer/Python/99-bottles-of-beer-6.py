#!/usr/bin/env python3
"""\
{0} {2} of beer on the wall
{0} {2} of beer
Take one down, pass it around
{1} {3} of beer on the wall
"""
print("\n".join(
    __doc__.format(
        i, i - 1,
        "bottle" if i == 1 else "bottles",
        "bottle" if i - 1 == 1 else "bottles"
    ) for i in range(99, 0, -1)
), end="")
