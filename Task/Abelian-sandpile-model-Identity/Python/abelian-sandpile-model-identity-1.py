from itertools import product
from collections import defaultdict


class Sandpile():
    def __init__(self, gridtext):
        array = [int(x) for x in gridtext.strip().split()]
        self.grid = defaultdict(int,
                                {(i //3, i % 3): x
                                 for i, x in enumerate(array)})

    _border = set((r, c)
                  for r, c in product(range(-1, 4), repeat=2)
                  if not 0 <= r <= 2 or not 0 <= c <= 2
                  )
    _cell_coords = list(product(range(3), repeat=2))

    def topple(self):
        g = self.grid
        for r, c in self._cell_coords:
            if g[(r, c)] >= 4:
                g[(r - 1, c)] += 1
                g[(r + 1, c)] += 1
                g[(r, c - 1)] += 1
                g[(r, c + 1)] += 1
                g[(r, c)] -= 4
                return True
        return False

    def stabilise(self):
        while self.topple():
            pass
        # Remove extraneous grid border
        g = self.grid
        for row_col in self._border.intersection(g.keys()):
            del g[row_col]
        return self

    __pos__ = stabilise     # +s == s.stabilise()

    def __eq__(self, other):
        g = self.grid
        return all(g[row_col] == other.grid[row_col]
                   for row_col in self._cell_coords)

    def __add__(self, other):
        g = self.grid
        ans = Sandpile("")
        for row_col in self._cell_coords:
            ans.grid[row_col] = g[row_col] + other.grid[row_col]
        return ans.stabilise()

    def __str__(self):
        g, txt = self.grid, []
        for row in range(3):
            txt.append(' '.join(str(g[(row, col)])
                                for col in range(3)))
        return '\n'.join(txt)

    def __repr__(self):
        return f'{self.__class__.__name__}(""""\n{self.__str__()}""")'


unstable = Sandpile("""
4 3 3
3 1 2
0 2 3""")
s1 = Sandpile("""
    1 2 0
    2 1 1
    0 1 3
""")
s2 = Sandpile("""
    2 1 3
    1 0 1
    0 1 0
""")
s3 = Sandpile("3 3 3  3 3 3  3 3 3")
s3_id = Sandpile("2 1 2  1 0 1  2 1 2")
