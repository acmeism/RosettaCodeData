EPS = 0.001
EPS_SQUARE = EPS * EPS

def side(x1, y1, x2, y2, x, y)
    return (y2 - y1) * (x - x1) + (-x2 + x1) * (y - y1)
end

def naivePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
    checkSide1 = side(x1, y1, x2, y2, x, y) >= 0
    checkSide2 = side(x2, y2, x3, y3, x, y) >= 0
    checkSide3 = side(x3, y3, x1, y1, x, y) >= 0
    return checkSide1 && checkSide2 && checkSide3
end

def pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y)
    xMin = [x1, x2, x3].min - EPS
    xMax = [x1, x2, x3].max + EPS
    yMin = [y1, y2, y3].min - EPS
    yMax = [y1, y2, y3].max + EPS
    return !(x < xMin || xMax < x || y < yMin || yMax < y)
end

def distanceSquarePointToSegment(x1, y1, x2, y2, x, y)
    p1_p2_squareLength = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
    dotProduct = ((x - x1) * (x2 - x1) + (y - y1) * (y2 - y1)) / p1_p2_squareLength
    if dotProduct < 0 then
        return (x - x1) * (x - x1) + (y - y1) * (y - y1)
    end
    if dotProduct <= 1 then
        p_p1_squareLength = (x1 - x) * (x1 - x) + (y1 - y) * (y1 - y)
        return p_p1_squareLength - dotProduct * dotProduct * p1_p2_squareLength
    end
    return (x - x2) * (x - x2) + (y - y2) * (y - y2)
end

def accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
    if !pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y) then
        return false
    end
    if naivePointInTriangle(x1, y1, x2, y2, x3, y3, x, y) then
        return true
    end
    if distanceSquarePointToSegment(x1, y1, x2, y2, x, y) <= EPS_SQUARE then
        return true
    end
    if distanceSquarePointToSegment(x2, y2, x3, y3, x, y) <= EPS_SQUARE then
        return true
    end
    if distanceSquarePointToSegment(x3, y3, x1, y1, x, y) <= EPS_SQUARE then
        return true
    end
    return false
end

def main
    pts = [[0, 0], [0, 1], [3, 1]]
    tri = [[1.5, 2.4], [5.1, -3.1], [-3.8, 1.2]]
    print "Triangle is ", tri, "\n"
    x1, y1 = tri[0][0], tri[0][1]
    x2, y2 = tri[1][0], tri[1][1]
    x3, y3 = tri[2][0], tri[2][1]
    for pt in pts
        x, y = pt[0], pt[1]
        within = accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
        print "Point ", pt, " is within triangle? ", within, "\n"
    end
    print "\n"

    tri = [[0.1, 1.0 / 9.0], [12.5, 100.0 / 3.0], [25.0, 100.0 / 9.0]]
    print "Triangle is ", tri, "\n"
    x1, y1 = tri[0][0], tri[0][1]
    x2, y2 = tri[1][0], tri[1][1]
    x3, y3 = tri[2][0], tri[2][1]
    x = x1 + (3.0 / 7.0) * (x2 - x1)
    y = y1 + (3.0 / 7.0) * (y2 - y1)
    pt = [x, y]
    within = accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
    print "Point ", pt, " is within triangle? ", within, "\n"
    print "\n"

    tri = [[0.1, 1.0 / 9.0], [12.5, 100.0 / 3.0], [-12.5, 100.0 / 6.0]]
    print "Triangle is ", tri, "\n"
    x3, y3 = tri[2][0], tri[2][1]
    within = accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
    print "Point ", pt, " is within triangle? ", within, "\n"
end

main()
