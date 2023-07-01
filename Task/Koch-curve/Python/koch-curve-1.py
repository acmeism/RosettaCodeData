'''Koch curve'''

from math import cos, pi, sin
from operator import add, sub
from itertools import chain


# kochSnowflake :: Int -> (Float, Float) -> (Float, Float) -> [(Float, Float)]
def kochSnowflake(n, a, b):
    '''List of points on a Koch snowflake of order n, derived
       from an equilateral triangle with base a b.
    '''
    points = [a, equilateralApex(a, b), b]
    return chain.from_iterable(map(
        kochCurve(n),
        points,
        points[1:] + [points[0]]
    ))


# kochCurve :: Int -> (Float, Float) -> (Float, Float)
#                  -> [(Float, Float)]
def kochCurve(n):
    '''List of points on a Koch curve of order n,
       starting at point ab, and ending at point xy.
    '''
    def koch(n):
        def goTuple(abxy):
            ab, xy = abxy
            if 0 == n:
                return [xy]
            else:
                mp, mq = midThirdOfLine(ab, xy)
                points = [
                    ab,
                    mp,
                    equilateralApex(mp, mq),
                    mq,
                    xy
                ]
                return list(
                    chain.from_iterable(map(
                        koch(n - 1),
                        zip(points, points[1:])
                    ))
                )
        return goTuple

    def go(ab, xy):
        return [ab] + koch(n)((ab, xy))
    return go


# equilateralApex :: (Float, Float) -> (Float, Float) -> (Float, Float)
def equilateralApex(p, q):
    '''Apex of triangle with base p q.
    '''
    return rotatedPoint(pi / 3)(p, q)


# rotatedPoint :: Float -> (Float, Float) ->
#                (Float, Float) -> (Float, Float)
def rotatedPoint(theta):
    '''The point ab rotated theta radians
        around the origin xy.
    '''
    def go(xy, ab):
        ox, oy = xy
        a, b = ab
        dx, dy = rotatedVector(theta, (a - ox, oy - b))
        return ox + dx, oy - dy
    return go


# rotatedVector :: Float -> (Float, Float) -> (Float, Float)
def rotatedVector(theta, xy):
    '''The vector xy rotated by theta radians.
    '''
    x, y = xy
    return (
        x * cos(theta) - y * sin(theta),
        x * sin(theta) + y * cos(theta)
    )


# midThirdOfLine :: (Float, Float) -> (Float, Float)
#                -> ((Float, Float), (Float, Float))
def midThirdOfLine(ab, xy):
    '''Second of three equal segments of
       the line between ab and xy.
    '''
    vector = [x / 3 for x in map(sub, xy, ab)]

    def f(p):
        return tuple(map(add, vector, p))
    p = f(ab)
    return (p, f(p))


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''SVG for Koch snowflake of order 4.
    '''
    print(
        svgFromPoints(1024)(
            kochSnowflake(
                4, (200, 600), (800, 600)
            )
        )
    )


# -------------------------- SVG ---------------------------

# svgFromPoints :: Int -> [(Float, Float)] -> SVG String
def svgFromPoints(w):
    '''Width of square canvas -> Point list -> SVG string.
    '''
    def go(xys):
        xs = ' '.join(map(
            lambda xy: str(round(xy[0], 2)) + ' ' + str(round(xy[1], 2)),
            xys
        ))
        return '\n'.join([
            '<svg xmlns="http://www.w3.org/2000/svg"',
            f'width="512" height="512" viewBox="5 5 {w} {w}">',
            f'<path d="M{xs}" ',
            'stroke-width="2" stroke="red" fill="transparent"/>',
            '</svg>'
        ])
    return go


# MAIN ---
if __name__ == '__main__':
    main()
