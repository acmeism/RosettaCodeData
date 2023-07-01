import urllib.request
from collections import Counter


GRID = """
N 	D 	E
O 	K 	G
E 	L 	W
"""


def getwords(url='http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'):
    "Return lowercased words of 3 to 9 characters"
    words = urllib.request.urlopen(url).read().decode().strip().lower().split()
    return (w for w in words if 2 < len(w) < 10)

def solve(grid, dictionary):
    gridcount = Counter(grid)
    mid = grid[4]
    return [word for word in dictionary
            if mid in word and not (Counter(word) - gridcount)]


if __name__ == '__main__':
    chars = ''.join(GRID.strip().lower().split())
    found = solve(chars, dictionary=getwords())
    print('\n'.join(found))
