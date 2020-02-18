#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Pythonic 99 beer song (maybe the simplest naive implementation in Python 3)."""


REGULAR_VERSE = '''\
{n} bottles of beer on the wall, {n} bottles of beer
Take one down and pass it around, {n_minus_1} bottles of beer on the wall.

'''

ENDING_VERSES = '''\
2 bottles of beer on the wall, 2 bottles of beer.
Take one down and pass it around, 1 bottle of beer on the wall.

1 bottle of beer on the wall, 1 bottle of beer.
Take one down and pass it around, no more bottles of beer on the wall.

No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.

'''


for n in range(99, 2, -1):
    print(REGULAR_VERSE.format(n=n, n_minus_1=n - 1))
print(ENDING_VERSES)
