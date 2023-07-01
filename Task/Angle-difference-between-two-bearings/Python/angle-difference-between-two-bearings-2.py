'''Difference between two bearings'''

from math import (acos, cos, pi, sin)


# bearingDelta :: Radians -> Radians -> Radians
def bearingDelta(ar):
    '''Difference between two bearings,
       expressed in radians.'''
    def go(br):
        [(ax, ay), (bx, by)] = [
            (sin(x), cos(x)) for x in [ar, br]
        ]
        # cross-product > 0 ?
        sign = +1 if 0 < ((ay * bx) - (by * ax)) else -1
        # sign * dot-product
        return sign * acos((ax * bx) + (ay * by))
    return lambda br: go(br)


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test and display'''

    # showMap :: Degrees -> Degrees -> String
    def showMap(da, db):
        return unwords(
            str(x).rjust(n) for n, x in
            [
                (22, str(da) + ' +'),
                (24, str(db) + '  -> '),
                (7, round(
                    degrees(
                        bearingDelta
                        (radians(da))
                        (radians(db))
                    ), 2)
                 )
            ]
        )

    print(__doc__ + ':')
    print(
        unlines(showMap(a, b) for a, b in [
            (20, 45),
            (-45, 45),
            (-85, 90),
            (-95, 90),
            (-45, 125),
            (-45, 145),
            (-70099.74233810938, 29840.67437876723),
            (-165313.6666297357, 33693.9894517456),
            (1174.8380510598456, -154146.66490124757),
            (60175.77306795546, 42213.07192354373)
        ]))


# GENERIC ----------------------------------------------


# radians :: Float x => Degrees x -> Radians x
def radians(x):
    '''Radians derived from degrees.'''
    return pi * x / 180


# degrees :: Float x => Radians x -> Degrees x
def degrees(x):
    '''Degrees derived from radians.'''
    return 180 * x / pi


# unlines :: [String] -> String
def unlines(xs):
    '''A single newline-delimited string derived
       from a list of strings.'''
    return '\n'.join(xs)


# unwords :: [String] -> String
def unwords(xs):
    '''A space-separated string derived from
       a list of words.'''
    return ' '.join(xs)


if __name__ == '__main__':
    main()
