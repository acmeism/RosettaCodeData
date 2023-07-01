EPS = 0.001
EPS_SQUARE = EPS * EPS

function side(x1, y1, x2, y2, x, y)
    return (y2 - y1) * (x - x1) + (-x2 + x1) * (y - y1)
end

function naivePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
    local checkSide1 = side(x1, y1, x2, y2, x, y) >= 0
    local checkSide2 = side(x2, y2, x3, y3, x, y) >= 0
    local checkSide3 = side(x3, y3, x1, y1, x, y) >= 0
    return checkSide1 and checkSide2 and checkSide3
end

function pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y)
    local xMin = math.min(x1, x2, x3) - EPS
    local xMax = math.max(x1, x2, x3) + EPS
    local yMin = math.min(y1, y2, y3) - EPS
    local yMax = math.max(y1, y2, y3) + EPS
    return not (x < xMin or xMax < x or y < yMin or yMax < y)
end

function distanceSquarePointToSegment(x1, y1, x2, y2, x, y)
    local p1_p2_squareLength = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
    local dotProduct = ((x - x1) * (x2 - x1) + (y - y1) * (y2 - y1)) / p1_p2_squareLength
    if dotProduct < 0 then
        return (x - x1) * (x - x1) + (y - y1) * (y - y1)
    end
    if dotProduct <= 1 then
        local p_p1_squareLength = (x1 - x) * (x1 - x) + (y1 - y) * (y1 - y)
        return p_p1_squareLength - dotProduct * dotProduct * p1_p2_squareLength
    end
    return (x - x2) * (x - x2) + (y - y2) * (y - y2)
end

function accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
    if not pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y) then
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

function printPoint(x, y)
    io.write('('..x..", "..y..')')
end

function printTriangle(x1, y1, x2, y2, x3, y3)
    io.write("Triangle is [")
    printPoint(x1, y1)
    io.write(", ")
    printPoint(x2, y2)
    io.write(", ")
    printPoint(x3, y3)
    print("]")
end

function test(x1, y1, x2, y2, x3, y3, x, y)
    printTriangle(x1, y1, x2, y2, x3, y3)
    io.write("Point ")
    printPoint(x, y)
    print(" is within triangle? " .. tostring(accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)))
end

test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 0, 0)
test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 0, 1)
test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 3, 1)
print()

test(0.1, 0.1111111111111111, 12.5, 33.333333333333336, 25, 11.11111111111111, 5.414285714285714, 14.349206349206348)
print()

test(0.1, 0.1111111111111111, 12.5, 33.333333333333336, -12.5, 16.666666666666668, 5.414285714285714, 14.349206349206348)
print()
