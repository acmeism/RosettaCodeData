#!/bin/env python3
#
#               *  *  *
#
# This is the algorithm that was introduced with the Icon example, and
# perhaps is new (at least in its details). It works by putting both
# curves into the symmetric power basis, then first breaking them at
# their critical points, then doing an adaptive flattening process
# until the problem is reduced to the intersection of two
# lines. Possible lines of inquiry are pruned by looking for overlap
# of the rectangles formed by the endpoints of curve portions.
#
# Unlike Icon, Python does not have goal-directed evaluation
# (GDE). What Python DOES have are "iterables" and
# "comprehensions". Where you see "yield" and comprehensions in the
# Python you will likely see "suspend" and "every" in the Icon.
#
# To put it another way: In Python, there are objects that "can be
# iterated over". In Icon, there are objects that "can produce values
# more than once". In either case, the objects are equivalent to a set
# (albeit an ordered set), and really what THIS algorithm deals with
# is (unordered) sets.
#
# Another thing about Icon to be aware of, when comparing this
# algorithm's implementations, is that Icon does not have boolean
# expressions. It has "succeed" and "fail". An Icon expression either
# "succeeds" and has a value or it "fails" and has no value. An "if"
# construct tests whether an expression succeeded, not what the
# expression's value is. (Booleans are easily "faked", of course, if
# you want them. The language variant Object Icon explicitly
# introduces &yes and &no as boolean values.)
#
#               *  *  *
#
# References on the symmetric power basis:
#
#    J. Sánchez-Reyes, ‘The symmetric analogue of the polynomial power
#        basis’, ACM Transactions on Graphics, vol 16 no 3, July 1997,
#        page 319.
#
#    J. Sánchez-Reyes, ‘Applications of the polynomial s-power basis
#        in geometry processing’, ACM Transactions on Graphics, vol 19
#        no 1, January 2000, page 35.
#

def length(ax, ay):
    '''Length according to some norm, where (ax,ay) is a "measuring
    stick" vector. Here I use the max norm.'''
    assert isinstance(ax, float)
    assert isinstance(ay, float)
    return max(abs(ax), abs(ay))

def compare_lengths(ax, ay, bx, by):
    '''Having a compare_lengths function lets one compare lengths in
    the euclidean metric by comparing the squares of the lengths, and
    thus avoiding the square root. The following, however, is a
    general implementation.'''
    assert isinstance(ax, float)
    assert isinstance(ay, float)
    assert isinstance(bx, float)
    assert isinstance(by, float)
    len_a = length(ax, ay)
    len_b = length(bx, by)
    if len_a < len_b:
        cmpval = -1
    elif len_a > len_b:
        cmpval = 1
    else:
        cmpval = 0
    return cmpval

def rectangles_overlap(a0, a1, b0, b1):
    '''Do the rectangles with corners at (a0,a1) and (b0,b1) overlap
    at all?'''
    assert isinstance(a0, Point)
    assert isinstance(a1, Point)
    assert isinstance(b0, Point)
    assert isinstance(b1, Point)
    return ((min(a0.x, a1.x) <= max(b0.x, b1.x))
            and (min(b0.x, b1.x) <= max(a0.x, a1.x))
            and (min(a0.y, a1.y) <= max(b0.y, b1.y))
            and (min(b0.y, b1.y) <= max(a0.y, a1.y)))

def segment_parameters(a0, a1, b0, b1):
    '''Do the line segments (a0,a1) and (b0,b1) intersect?  If so,
    return a tuple of their t-parameter values for the point of
    intersection, treating them as parametric splines of degree
    1. Otherwise return None.'''
    assert isinstance(a0, Point)
    assert isinstance(a1, Point)
    assert isinstance(b0, Point)
    assert isinstance(b1, Point)

    retval = None

    axdiff = a1.x - a0.x
    aydiff = a1.y - a0.y
    bxdiff = b1.x - b0.x
    bydiff = b1.y - b0.y

    denom = (axdiff * bydiff) - (aydiff * bxdiff)

    anumer = ((bxdiff * a0.y) - (bydiff * a0.x)
              + (b0.x * b1.y) - (b1.x * b0.y))
    ta = anumer / denom
    if 0.0 <= ta and ta <= 1.0:
        bnumer = -((axdiff * b0.y) - (aydiff * b0.x)
                   + (a0.x * a1.y) - (a1.x * a0.y))
        tb = bnumer / denom
        if 0.0 <= tb and tb <= 1.0:
            retval = (ta, tb)

    return retval

class Point:
    def __init__(self, x, y):
        assert isinstance(x, float)
        assert isinstance(y, float)
        self.x = x
        self.y = y

class SPower:
    '''Non-parametric spline in s-power basis.'''

    def __init__(self, c0, c1, c2):
        assert isinstance(c0, float)
        assert isinstance(c1, float)
        assert isinstance(c2, float)
        self.c0 = c0
        self.c1 = c1
        self.c2 = c2

    def val(self, t):
        '''Evaluate at t.'''
        assert isinstance(t, float)
        return (self.c0 + (self.c1 * t)) * (1.0 - t) + (self.c2 * t)

    def center_coef(self, t0, t1):
        '''Return the center coefficient for the [t0,t1] portion. (The
        other coefficients can be found with the val method.)'''
        assert isinstance(t0, float)
        assert isinstance(t1, float)
        return self.c1 * ((t1 - t0 - t0) * t1 + (t0 * t0))

    def critical_points(self):
        '''Return a set of independent variable values for the
        critical points that lie in (0,1).'''
        critpoints = set()
        if self.c1 != 0:    # If c1 is zero then the spline is linear.
            if self.c0 == self.c2:
                critpoints = {0.5} # The spline is "pulse-like".
            else:
                # The root of the derivative is the critical point.
                t = (0.5 * (self.c2 + self.c1 - self.c0)) / self.c1
                if 0.0 < t and t < 1.0:
                    critpoints = {t}
        return critpoints

class Curve:
    '''Parametric spline in s-power basis.'''

    def __init__(self, x, y):
        assert isinstance(x, SPower)
        assert isinstance(y, SPower)
        self.x = x
        self.y = y

    @staticmethod
    def from_controls(ctl0, ctl1, ctl2):
        assert isinstance(ctl0, Point)
        assert isinstance(ctl1, Point)
        assert isinstance(ctl2, Point)
        c0x = ctl0.x
        c0y = ctl0.y
        c1x = (2.0 * ctl1.x) - ctl0.x - ctl2.x
        c1y = (2.0 * ctl1.y) - ctl0.y - ctl2.y
        c2x = ctl2.x
        c2y = ctl2.y
        return Curve(SPower(c0x, c1x, c2x),
                     SPower(c0y, c1y, c2y))

    def val(self, t):
        '''Evaluate at t.'''
        assert isinstance(t, float)
        return Point(self.x.val(t), self.y.val(t))

    def critical_points(self):
        '''Return a set of t-parameter values for the critical points
        that lie in (0,1).'''
        return (self.x.critical_points() | self.y.critical_points())

class Portion:
    '''Portion of a parametric spline in [t0,t1].'''

    default_num_pieces = 2

    def __init__(self, curve, t0, t1, endpt0, endpt1):
        assert isinstance(curve, Curve)
        assert isinstance(t0, float)
        assert isinstance(t1, float)
        assert isinstance(endpt0, Point)
        assert isinstance(endpt1, Point)
        self.curve = curve
        self.t0 = t0
        self.t1 = t1
        self.endpt0 = endpt0
        self.endpt1 = endpt1

    def flat_enough(self, tol):
        '''Is the Portion close enough to linear to be treated as a
        line segment?'''

        # The degree-2 s-power polynomials are 1-t, t(1-t), t. We want
        # to remove the terms in t(1-t). The maximum of t(1-t) is 1/4,
        # reached at t=1/2. That accounts for the 1/4=0.25 in the
        # following.

        xcentercoef = self.curve.x.center_coef(self.t0, self.t1)
        ycentercoef = self.curve.y.center_coef(self.t0, self.t1)
        xlen = self.endpt1.x - self.endpt0.x
        ylen = self.endpt1.y - self.endpt0.y
        return compare_lengths(0.25 * xcentercoef,
                               0.25 * ycentercoef,
                               tol * xlen, tol * ylen) <= 0

    def split(self, num_pieces = default_num_pieces):
        '''Generate num_pieces sections of the Portion.'''
        assert isinstance(num_pieces, int)
        assert 2 <= num_pieces
        k = 1.0 / num_pieces
        ts = [(1.0 - (k * i)) * self.t0 + (k * i) * self.t1
              for i in range(1, num_pieces)]
        vals = [self.curve.val(t) for t in ts]
        ts = [self.t0] + ts + [self.t1]
        vals = [self.endpt0] + vals + [self.endpt1]
        for i in range(len(ts) - 1):
            yield Portion(self.curve, ts[i], ts[i + 1],
                          vals[i], vals[i + 1])

def find_intersections(p, q, tol):
    '''Generate t-parameter pairs detected as corresponding to
    intersection points of p and q. There may be duplicate
    detections. It is assumed those will be weeded out by later
    processing. The tol parameter specifies the "flatness tolerance"
    and is a relative tolerance.'''
    assert isinstance(p, Curve)
    assert isinstance(q, Curve)

    # The initial workload is the cartesian product of the monotonic
    # portions of p and q, respectively.
    tp = [0.0] + sorted(p.critical_points()) + [1.0]
    tq = [0.0] + sorted(q.critical_points()) + [1.0]
    workload = {(Portion(p, tp[i], tp[i + 1],
                         p.val(tp[i]), p.val(tp[i + 1])),
                 Portion(q, tq[j], tq[j + 1],
                         q.val(tq[j]), q.val(tq[j + 1])))
                for i in range(len(tp) - 1)
                for j in range(len(tq) - 1)}

    while len(workload) != 0:
        (pportion, qportion) = workload.pop()
        if rectangles_overlap(pportion.endpt0, pportion.endpt1,
                              qportion.endpt0, qportion.endpt1):
            if pportion.flat_enough(tol):
                if qportion.flat_enough(tol):
                    params = segment_parameters(pportion.endpt0,
                                                pportion.endpt1,
                                                qportion.endpt0,
                                                qportion.endpt1)
                    if params is not None:
                        (tp, tq) = params
                        tp = (1 - tp) * pportion.t0 + tp * pportion.t1
                        tq = (1 - tq) * qportion.t0 + tq * qportion.t1
                        yield (tp, tq)
                else:
                    workload |= {(pportion, qport)
                                 for qport in qportion.split()}
            else:
                if qportion.flat_enough(tol):
                    workload |= {(pport, qportion)
                                 for pport in pportion.split()}
                else:
                    workload |= {(pport, qport)
                                 for pport in pportion.split()
                                 for qport in qportion.split()}

if __name__ == '__main__':
    flatness_tolerance = 0.0001
    minimum_spacing = 0.000001

    p = Curve.from_controls(Point(-1.0, 0.0),
                            Point(0.0, 10.0),
                            Point(1.0, 0.0))
    q = Curve.from_controls(Point(2.0, 1.0),
                            Point(-8.0, 2.0),
                            Point( 2.0, 3.0))

    intersections = dict()
    for (tp, tq) in find_intersections(p, q, flatness_tolerance):
        pval = p.val(tp)
        qval = q.val(tq)
        if all([(minimum_spacing <=
                 length(pval.x - intersections[t][1].x,
                        pval.y - intersections[t][1].y))
                and (minimum_spacing <=
                     length(qval.x - intersections[t][3].x,
                            qval.y - intersections[t][3].y))
                for t in intersections]):
            intersections[tp] = (tp, pval, tq, qval)

    print()
    print('          convex up                ',
          '                   convex left');
    for k in sorted(intersections):
        (tp, pointp, tq, pointq) = intersections[k]
        print((" %11.8f   (%11.8f, %11.8f)     " +
               "%11.8f   (%11.8f, %11.8f)")
              %(tp, pointp.x, pointp.y, tq, pointq.x, pointq.y))
    print()
