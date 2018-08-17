"""Pythonic 99 beer song (readability counts)."""

first = '''\
99 bottles of beer on the wall, 99 bottles of beer
'''

middle = '''\
Take one down and pass it around, {n} bottles of beer on the wall.

{n} bottles of beer on the wall, {n} bottles of beer
'''

last = '''\
Take one down and pass it around, 1 bottle of beer on the wall.

1 bottle of beer on the wall, 1 bottle of beer.
Take one down and pass it around, no more bottles of beer on the wall.

No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.
'''

print(first)
for n in range(98, 1, -1):
    print(middle.format(n=n))
print(last)
