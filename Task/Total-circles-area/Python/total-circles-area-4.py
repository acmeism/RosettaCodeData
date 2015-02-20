from collections import namedtuple
from functools import partial
from itertools import repeat, imap, izip
from decimal import Decimal, getcontext

# Requires the egg: https://pypi.python.org/pypi/dmath/
from dmath import atan2, asin, sin, cos, pi as piCompute

getcontext().prec = 40 # Set FP precision.
sqrt = Decimal.sqrt
pi = piCompute()
D2 = Decimal(2)

Vec = namedtuple("Vec", "x y")
vcross = lambda (a, b), (c, d): a*d - b*c
vdot   = lambda (a, b), (c, d): a*c + b*d
vadd   = lambda (a, b), (c, d): Vec(a + c, b + d)
vsub   = lambda (a, b), (c, d): Vec(a - c, b - d)
vlen   = lambda x: sqrt(vdot(x, x))
vdist  = lambda a, b: vlen(vsub(a, b))
vscale = lambda s, (x, y): Vec(x * s, y * s)

def vnorm(v):
    l = vlen(v)
    return Vec(v.x / l, v.y / l)

vangle = lambda (x, y): atan2(y, x)

def anorm(a):
    if a > pi:  return a - pi * D2
    if a < -pi: return a + pi * D2
    return             a

Circle = namedtuple("Circle", "x y r")

def circle_cross((x0, y0, r0), (x1, y1, r1)):
    d = vdist(Vec(x0, y0), Vec(x1, y1))
    if d >= r0 + r1 or d <= abs(r0 - r1):
        return []

    s = (r0 + r1 + d) / D2
    a = sqrt(s * (s - d) * (s - r0) * (s - r1))
    h = D2 * a / d
    dr = Vec(x1 - x0, y1 - y0)
    dx = vscale(sqrt(r0 ** 2 - h ** 2), vnorm(dr))
    ang = vangle(dr) if \
          r0 ** 2 + d ** 2 > r1 ** 2 \
          else pi + vangle(dr)
    da = asin(h / r0)
    return map(anorm, [ang - da, ang + da])

# Angles of the start and end points of the circle arc.
Angle2 = namedtuple("Angle2", "a1 a2")

Arc = namedtuple("Arc", "c aa")

arcPoint = lambda (x, y, r), a: \
    vadd(Vec(x, y), Vec(r * cos(a), r * sin(a)))

arc_start  = lambda (c, (a0, a1)):  arcPoint(c, a0)
arc_mid    = lambda (c, (a0, a1)):  arcPoint(c, (a0 + a1) / D2)
arc_end    = lambda (c, (a0, a1)):  arcPoint(c, a1)
arc_center = lambda ((x, y, r), _): Vec(x, y)

arc_area = lambda ((_0, _1, r), (a0, a1)):  r ** 2 * (a1 - a0) / D2

def split_circles(cs):
    cSplit = lambda (c, angs): \
        imap(Arc, repeat(c), imap(Angle2, angs, angs[1:]))

    # If an arc that was part of one circle is inside *another* circle,
    # it will not be part of the zero-winding path, so reject it.
    in_circle = lambda ((x0, y0), c), (x, y, r): \
        c != Circle(x, y, r) and vdist(Vec(x0, y0), Vec(x, y)) < r

    def in_any_circle(arc):
        return any(in_circle((arc_mid(arc), arc.c), c) for c in cs)

    concat_map = lambda f, xs: [y for x in xs for y in f(x)]

    f = lambda c: \
        (c, sorted([-pi, pi] +
                   concat_map(partial(circle_cross, c), cs)))
    cAngs = map(f, cs)
    arcs = concat_map(cSplit, cAngs)
    return filter(lambda ar: not in_any_circle(ar), arcs)

# Given a list of arcs, build sets of closed paths from them.
# If one arc's end point is no more than 1e-4 from another's
# start point, they are considered connected.  Since these
# start/end points resulted from intersecting circles earlier,
# they *should* be exactly the same, but floating point
# precision may cause small differences, hence the 1e-4 error
# margin.  When there are genuinely different intersections
# closer than this margin, the method will backfire, badly.
def make_paths(arcs):
    eps = Decimal("0.0001")
    def join_arcs(a, xxs):
        if not xxs:
            return [a]
        x, xs = xxs[0], xxs[1:]
        if not a:
            return join_arcs([x], xs)
        if vdist(arc_start(a[0]), arc_end(a[-1])) < eps:
            return [a] + join_arcs([], xxs)
        if vdist(arc_end(a[-1]), arc_start(x)) < eps:
            return join_arcs(a + [x], xs)
        return join_arcs(a, xs + [x])
    return join_arcs([], arcs)

# Slice N-polygon into N-2 triangles.
def polyline_area(vvs):
    tri_area = lambda a, b, c: vcross(vsub(b, a), vsub(c, b)) / D2
    v, vs = vvs[0], vvs[1:]
    return sum(tri_area(v, v1, v2) for v1, v2 in izip(vs, vs[1:]))

def path_area(arcs):
    f = lambda (a, e), arc: \
        (a + arc_area(arc), e + [arc_center(arc), arc_end(arc)])
    (a, e) = reduce(f, arcs, (0, []))
    return a + polyline_area(e)

circles_area = lambda cs: \
    sum(imap(path_area, make_paths(split_circles(cs))))

def main():
    raw_circles = """\
         1.6417233788  1.6121789534 0.0848270516
        -1.4944608174  1.2077959613 1.1039549836
         0.6110294452 -0.6907087527 0.9089162485
         0.3844862411  0.2923344616 0.2375743054
        -0.2495892950 -0.3832854473 1.0845181219
         1.7813504266  1.6178237031 0.8162655711
        -0.1985249206 -0.8343333301 0.0538864941
        -1.7011985145 -0.1263820964 0.4776976918
        -0.4319462812  1.4104420482 0.7886291537
         0.2178372997 -0.9499557344 0.0357871187
        -0.6294854565 -1.3078893852 0.7653357688
         1.7952608455  0.6281269104 0.2727652452
         1.4168575317  1.0683357171 1.1016025378
         1.4637371396  0.9463877418 1.1846214562
        -0.5263668798  1.7315156631 1.4428514068
        -1.2197352481  0.9144146579 1.0727263474
        -0.1389358881  0.1092805780 0.7350208828
         1.5293954595  0.0030278255 1.2472867347
        -0.5258728625  1.3782633069 1.3495508831
        -0.1403562064  0.2437382535 1.3804956588
         0.8055826339 -0.0482092025 0.3327165165
        -0.6311979224  0.7184578971 0.2491045282
         1.4685857879 -0.8347049536 1.3670667538
        -0.6855727502  1.6465021616 1.0593087096
         0.0152957411  0.0638919221 0.9771215985""".splitlines()

    circles = [Circle(*imap(Decimal, row.split()))
               for row in raw_circles]
    print "Total Area:", circles_area(circles)

main()
