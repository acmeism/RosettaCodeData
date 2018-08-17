"""Pythonic 99 beer song (readability counts)."""

regular_verse = '''\
{n} bottles of beer on the wall, {n} bottles of beer
Take one down and pass it around, {n_minus_1} bottles of beer on the wall.

'''

ending_verses = '''\
2 bottles of beer on the wall, 2 bottles of beer.
Take one down and pass it around, 1 bottle of beer on the wall.

1 bottle of beer on the wall, 1 bottle of beer.
Take one down and pass it around, no more bottles of beer on the wall.

No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.

'''

# @todo: It is possible to refactor the code to avoid n-1 in the code,
#        notice that the last line of any verse and the first line of the next
#        verse share the same number of bottles. Nevertheless the code
#        would be less readliable.

for n in range(99, 2, -1):
    print(regular_verse.format(n=n, n_minus_1=n - 1))
print(ending_verses)
