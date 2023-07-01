from collections import namedtuple
from math import sqrt

Pt = namedtuple('Pt', 'x, y')
Circle = Cir = namedtuple('Circle', 'x, y, r')

def circles_from_p1p2r(p1, p2, r):
    'Following explanation at http://mathforum.org/library/drmath/view/53027.html'
    if r == 0.0:
        raise ValueError('radius of zero')
    (x1, y1), (x2, y2) = p1, p2
    if p1 == p2:
        raise ValueError('coincident points gives infinite number of Circles')
    # delta x, delta y between points
    dx, dy = x2 - x1, y2 - y1
    # dist between points
    q = sqrt(dx**2 + dy**2)
    if q > 2.0*r:
        raise ValueError('separation of points > diameter')
    # halfway point
    x3, y3 = (x1+x2)/2, (y1+y2)/2
    # distance along the mirror line
    d = sqrt(r**2-(q/2)**2)
    # One answer
    c1 = Cir(x = x3 - d*dy/q,
             y = y3 + d*dx/q,
             r = abs(r))
    # The other answer
    c2 = Cir(x = x3 + d*dy/q,
             y = y3 - d*dx/q,
             r = abs(r))
    return c1, c2

if __name__ == '__main__':
    for p1, p2, r in [(Pt(0.1234, 0.9876), Pt(0.8765, 0.2345), 2.0),
                      (Pt(0.0000, 2.0000), Pt(0.0000, 0.0000), 1.0),
                      (Pt(0.1234, 0.9876), Pt(0.1234, 0.9876), 2.0),
                      (Pt(0.1234, 0.9876), Pt(0.8765, 0.2345), 0.5),
                      (Pt(0.1234, 0.9876), Pt(0.1234, 0.9876), 0.0)]:
        print('Through points:\n  %r,\n  %r\n  and radius %f\nYou can construct the following circles:'
              % (p1, p2, r))
        try:
            print('  %r\n  %r\n' % circles_from_p1p2r(p1, p2, r))
        except ValueError as v:
            print('  ERROR: %s\n' % (v.args[0],))
