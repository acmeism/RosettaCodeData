class Point
    include Comparable
    attr :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def <=>(other)
        x <=> other.x
    end

    def to_s
        "(%d, %d)" % [@x, @y]
    end

    def to_str
        to_s()
    end
end

def ccw(a, b, c)
    ((b.x - a.x) * (c.y - a.y)) > ((b.y - a.y) * (c.x - a.x))
end

def convexHull(p)
    if p.length == 0 then
        return []
    end

    p = p.sort
    h = []

    # Lower hull
    p.each { |pt|
        while h.length >= 2 and not ccw(h[-2], h[-1], pt)
            h.pop()
        end
        h << pt
    }

    # upper hull
    t = h.length + 1
    p.reverse.each { |pt|
        while h.length >= t and not ccw(h[-2], h[-1], pt)
            h.pop()
        end
        h << pt
    }

    h.pop()
    h
end

def main
    points = [
        Point.new(16,  3), Point.new(12, 17), Point.new( 0,  6), Point.new(-4, -6), Point.new(16,  6),
        Point.new(16, -7), Point.new(16, -3), Point.new(17, -4), Point.new( 5, 19), Point.new(19, -8),
        Point.new( 3, 16), Point.new(12, 13), Point.new( 3, -4), Point.new(17,  5), Point.new(-3, 15),
        Point.new(-3, -9), Point.new( 0, 11), Point.new(-9, -3), Point.new(-4, -2), Point.new(12, 10)
    ]
    hull = convexHull(points)
    print "Convex Hull: [", hull.join(", "), "]\n"
end

main()
