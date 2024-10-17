#= The control points of a planar quadratic Bézier curve form a
   triangle--called the "control polygon"--that completely contains
   the curve. Furthermore, the rectangle formed by the minimum and
   maximum x and y values of the control polygon completely contain
   the polygon, and therefore also the curve.

   Thus a simple method for narrowing down where intersections might
   be is: subdivide both curves until you find "small enough" regions
   where these rectangles overlap.
=#

mutable struct Point
    x::Float64
    y::Float64
    Point() = new(0, 0)
end

mutable struct QuadSpline # Non-parametric spline.
    c0::Float64
    c1::Float64
    c2::Float64
    QuadSpline(a = 0.0, b = 0.0, c = 0.0) = new(a, b, c)
end

mutable struct QuadCurve # Planar parametric spline.
    x::QuadSpline
    y::QuadSpline
    QuadCurve(x = QuadSpline(), y = QuadSpline()) = new(x, y)
end

const Workset = Tuple{QuadCurve, QuadCurve}

""" Subdivision by de Casteljau's algorithm. """
function subdivide!(q::QuadSpline, t::Float64, u::QuadSpline, v::QuadSpline)
    s = 1.0 - t
    c0 = q.c0
    c1 = q.c1
    c2 = q.c2
    u.c0 = c0
    v.c2 = c2
    u.c1 = s*c0 + t*c1
    v.c1 = s*c1 + t*c2
    u.c2 = s*u.c1 + t*v.c1
    v.c0 = u.c2
end

function subdivide!(q::QuadCurve, t::Float64, u::QuadCurve, v::QuadCurve)
    subdivide!(q.x, t, u.x, v.x)
    subdivide!(q.y, t, u.y, v.y)
end

""" It is assumed that xa0 <= xa1, ya0 <= ya1, xb0 <= xb1, and yb0 <= yb1. """
function rectsoverlap(xa0, ya0, xa1, ya1, xb0, yb0, xb1, yb1)
    return xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1
end

""" This accepts the point as an intersection if the boxes are small enough. """
function testintersect(p::QuadCurve, q::QuadCurve, tol::Float64, intersect::Point)
    pxmin = min(p.x.c0, p.x.c1, p.x.c2)
    pymin = min(p.y.c0, p.y.c1, p.y.c2)
    pxmax = max(p.x.c0, p.x.c1, p.x.c2)
    pymax = max(p.y.c0, p.y.c1, p.y.c2)

    qxmin = min(q.x.c0, q.x.c1, q.x.c2)
    qymin = min(q.y.c0, q.y.c1, q.y.c2)
    qxmax = max(q.x.c0, q.x.c1, q.x.c2)
    qymax = max(q.y.c0, q.y.c1, q.y.c2)

    exclude = true
    accept = false
    if rectsoverlap(pxmin, pymin, pxmax, pymax, qxmin, qymin, qxmax, qymax)
        exclude = false
        xmin = max(pxmin, qxmin)
        xmax = min(pxmax, pxmax)
        @assert xmin < xmax "Assertion failure: $xmax < $xmin"
        if xmax-xmin <= tol
            ymin = max(pymin, qymin)
            ymax = min(pymax, qymax)
            @assert ymin < ymax "Assertion failure: $ymax < $ymin"
            if ymax-ymin <= tol
                accept = true
                intersect.x = 0.5*xmin + 0.5*xmax
                intersect.y = 0.5*ymin + 0.5*ymax
            end
        end
    end
    return exclude, accept
end

""" return true if there seems to be a duplicate of xy in the intersects `isects` """
seemsduplicate(isects, xy, sp) = any(p -> abs(p.x-xy.x) < sp && abs(p.y-xy.y) < sp, isects)

""" find intersections of p and q """
function findintersects(p, q, tol, spacing)
    intersects = Point[]
    workload = Workset[(p, q)]
    while !isempty(workload)
        work = popfirst!(workload)
        intersect = Point()
        exclude, accept = testintersect(first(work), last(work), tol, intersect)
        if accept
            # To avoid detecting the same intersection twice, require some
            # space between intersections.
            if !seemsduplicate(intersects, intersect, spacing)
                pushfirst!(intersects, intersect)
            end
        elseif !exclude
            p0, p1, q0, q1 = QuadCurve(), QuadCurve(), QuadCurve(), QuadCurve()
            subdivide!(first(work), 0.5, p0, p1)
            subdivide!(last(work), 0.5, q0, q1)
            pushfirst!(workload, (p0, q0), (p0, q1), (p1, q0), (p1, q1))
        end
    end
    return intersects
end

""" test the methods """
function testintersections()
    p, q = QuadCurve(), QuadCurve()
    p.x = QuadSpline(-1.0, 0.0, 1.0)
    p.y = QuadSpline(0.0, 10.0, 0.0)
    q.x = QuadSpline(2.0, -8.0, 2.0)
    q.y = QuadSpline(1.0, 2.0, 3.0)
    tol = 0.0000001
    spacing = tol * 10
    for intersect in findintersects(p, q, tol, spacing)
        println("($(intersect.x) $(intersect.y))")
    end
end

testintersections()
