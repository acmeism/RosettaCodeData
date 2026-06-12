EPS = 1e-14

def sq(x)
    return x * x
end

def intersects(p1, p2, cp, r, segment)
    res = []
    (x0, y0) = cp
    (x1, y1) = p1
    (x2, y2) = p2
    aa = y2 - y1
    bb = x1 - x2
    cc = x2 * y1 - x1 * y2
    a = sq(aa) + sq(bb)
    if bb.abs >= EPS then
        b = 2 * (aa * cc + aa * bb * y0 - sq(bb) * x0)
        c = sq(cc) + 2 * bb * cc * y0 - sq(bb) * (sq(r) - sq(x0) - sq(y0))
        bnz = true
    else
        b = 2 * (bb * cc + aa * bb * x0 - sq(aa) * y0)
        c = sq(cc) + 2 * aa * cc * x0 - sq(aa) * (sq(r) - sq(x0) - sq(y0))
        bnz = false
    end
    d = sq(b) - 4 * a * c # disciminant
    if d < 0 then
        return res
    end

    # checks whether a point is within a segment
    within = ->(x, y) {
        d1 = Math.sqrt(sq(x2 - x1) + sq(y2 - y1))   # distance between end-points
        d2 = Math.sqrt(sq(x - x1) + sq(y - y1))     # distance from point to one end
        d3 = Math.sqrt(sq(x2 - x) + sq(y2 - y))     # distance from point to other end
        delta = d1 - d2 - d3
        return delta.abs < EPS                      # true if delta is less than a small tolerance
    }

    fx = ->(x) {
        return -(aa * x + cc) / bb
    }

    fy = ->(y) {
        return -(bb * y + cc) / aa
    }

    rxy = ->(x, y) {
        if not segment or within.call(x, y) then
            if x == 0.0 then
                x = 0.0
            end
            if y == 0.0 then
                y = 0.0
            end
            res << [x, y]
        end
    }

    if d == 0.0 then
        # line is tangent to circle, so just one intersect at most
        if bnz then
            x = -b / (2 * a)
            y = fx.call(x)
            rxy.call(x, y)
        else
            y = -b / (2 * a)
            x = fy.call(y)
            rxy.call(x, y)
        end
    else
        # two intersects at most
        d = Math.sqrt(d)
        if bnz then
            x = (-b + d) / (2 * a)
            y = fx.call(x)
            rxy.call(x, y)
            x = (-b - d) / (2 * a)
            y = fx.call(x)
            rxy.call(x, y)
        else
            y = (-b + d) / (2 * a)
            x = fy.call(y)
            rxy.call(x, y)
            y = (-b - d) / (2 * a)
            x = fy.call(y)
            rxy.call(x, y)
        end
    end

    return res
end

def main
    print "The intersection points (if any) between:\n"

    cp = [3.0, -5.0]
    r = 3.0
    print "  A circle, center %s with radius %f, and:\n" % [cp, r]

    p1 = [-10.0, 11.0]
    p2 = [10.0, -9.0]
    print "    a line containing the points %s and %s is/are:\n" % [p1, p2]
    print "      %s\n" % [intersects(p1, p2, cp, r, false)]

    p2 = [-10.0, 12.0]
    print "    a segment starting at %s and ending at %s is/are:\n" % [p1, p2]
    print "      %s\n" % [intersects(p1, p2, cp, r, true)]

    p1 = [3.0, -2.0]
    p2 = [7.0, -2.0]
    print "    a horizontal line containing the points %s and %s is/are:\n" % [p1, p2]
    print "      %s\n" % [intersects(p1, p2, cp, r, false)]

    cp = [0.0, 0.0]
    r = 4.0
    print "  A circle, center %s with radius %f, and:\n" % [cp, r]

    p1 = [0.0, -3.0]
    p2 = [0.0, 6.0]
    print "    a vertical line containing the points %s and %s is/are:\n" % [p1, p2]
    print "      %s\n" % [intersects(p1, p2, cp, r, false)]
    print "    a vertical line segment containing the points %s and %s is/are:\n" % [p1, p2]
    print "      %s\n" % [intersects(p1, p2, cp, r, true)]

    cp = [4.0, 2.0]
    r = 5.0
    print "  A circle, center %s with radius %f, and:\n" % [cp, r]

    p1 = [6.0, 3.0]
    p2 = [10.0, 7.0]
    print "    a line containing the points %s and %s is/are:\n" % [p1, p2]
    print "      %s\n" % [intersects(p1, p2, cp, r, false)]

    p1 = [7.0, 4.0]
    p2 = [11.0, 8.0]
    print "    a segment starting at %s and ending at %s is/are:\n" % [p1, p2]
    print "      %s\n" % [intersects(p1, p2, cp, r, true)]
end

main()
