'''Polygonal area by shoelace formula'''

from itertools import cycle, islice
from functools import reduce
from operator import sub

# --------- SHOELACE FORMULA FOR POLYGONAL AREA ----------

# shoelaceArea :: [(Float, Float)] -> Float
def shoelaceArea(xys):
    '''Area of polygon with vertices
       at (x, y) points in xys.
    '''
    def go(a, tpl):
        l, r = a
        (x, y), (dx, dy) = tpl
        return l + x * dy, r + y * dx

    return abs(sub(*reduce(
        go,
        zip(
            xys,
            islice(cycle(xys), 1, None)
        ),
        (0, 0)
    ))) / 2


# ------------------------- TEST -------------------------
# main :: IO()
def main():
    '''Sample calculation'''

    ps = [(3, 4), (5, 11), (12, 8), (9, 5), (5, 6)]
    print(__doc__ + ':')
    print(repr(ps) + '  ->  ' + str(shoelaceArea(ps)))


if __name__ == '__main__':
    main()
