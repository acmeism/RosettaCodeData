local Point = {}
Point.__index = Point

function Point.new(first, second)
    return setmetatable({first=first, second=second}, Point)
end

local function hypot(...)
    local sum = 0

    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        sum = sum + arg * arg
    end

    return math.sqrt(sum)
end

local function perpendicularDistance(point, lineStart, lineEnd)
    local dx = lineEnd.first - lineStart.first
    local dy = lineEnd.second - lineStart.second

    local mag = hypot(dx, dy)
    if mag > 0 then
        dx = dx / mag
        dy = dy / mag
    end

    local pvx = point.first - lineStart.first
    local pvy = point.second - lineStart.second

    local pvDot = dx * pvx + dy * pvy

    local ax = pvx - pvDot * dx
    local ay = pvy - pvDot * dy

    return hypot(ax, ay)
end

local function simplify(points, epsilon)
    local n = #points
    if n < 2 then
        error("Not enough points to simplify; needs at least 2 points, received " .. n .. " instead")
    end

    local dmax = 0
    local index = 1

    for i = 2, n - 1 do
        local d = perpendicularDistance(points[i], points[1], points[n])
        if d > dmax then
            index = i
            dmax = d
        end
    end

    if dmax > epsilon then
        local recursiveResults = {first={}, second={}}
        recursiveResults.first = simplify({table.unpack(points, 1, index)}, epsilon)
        recursiveResults.second = simplify({table.unpack(points, index, n)}, epsilon)
        local result = {}

        for i = 1, #recursiveResults.first - 1 do
            table.insert(result, recursiveResults.first[i])
        end
        for i = 1, #recursiveResults.second do
            table.insert(result, recursiveResults.second[i])
        end
        return result
    else
        return {points[1], points[n]}
    end
end

local points = {
    Point.new(0.0, 0.0),
    Point.new(1.0, 0.1),
    Point.new(2.0, -0.1),
    Point.new(3.0, 5.0),
    Point.new(4.0, 6.0),
    Point.new(5.0, 7.0),
    Point.new(6.0, 8.1),
    Point.new(7.0, 9.0),
    Point.new(8.0, 9.0),
    Point.new(9.0, 9.0)
}

local result = simplify(points, 1.0)
print("Points remaining after simplification:")
for i, v in ipairs(result) do
    print("(" .. v.first .. ", " .. v.second .. ")")
end
