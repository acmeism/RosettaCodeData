EPS = 1e-14

function pts(p)
    local x, y = p.x, p.y
    if x == 0 then
        x = 0
    end
    if y == 0 then
        y = 0
    end
    return "(" .. x .. ", " .. y .. ")"
end

function lts(pl)
    local str = "["
    for i,p in pairs(pl) do
        if i > 1 then
            str = str .. ", "
        end
        str = str .. pts(p)
    end
    return str .. "]"
end

function sq(x)
    return x * x
end

function intersects(p1, p2, cp, r, segment)
    local res = {}
    local x0, y0 = cp.x, cp.y
    local x1, y1 = p1.x, p1.y
    local x2, y2 = p2.x, p2.y
    local A = y2 - y1
    local B = x1 - x2
    local C = x2 * y1 - x1 * y2
    local a = sq(A) + sq(B)
    local b, c
    local bnz = true
    if math.abs(B) >= EPS then
        b = 2 * (A * C + A * B * y0 - sq(B) * x0)
        c = sq(C) + 2 * B * C * y0 - sq(B) * (sq(r) - sq(x0) - sq(y0))
    else
        b = 2 * (B * C + A * B * x0 - sq(A) * y0)
        c = sq(C) + 2 * A * C * x0 - sq(A) * (sq(r) - sq(x0) - sq(y0))
        bnz = false
    end
    local d = sq(b) - 4 * a * c -- discriminant
    if d < 0 then
        return res
    end

    -- checks whether a point is within a segment
    function within(x, y)
        local d1 = math.sqrt(sq(x2 - x1) + sq(y2 - y1)) -- distance between end-points
        local d2 = math.sqrt(sq(x - x1) + sq(y - y1))   -- distance from point to one end
        local d3 = math.sqrt(sq(x2 - x) + sq(y2 - y))   -- distance from point to other end
        local delta = d1 - d2 - d3
        return math.abs(delta) < EPS
    end

    function fx(x)
        return -(A * x + C) / B
    end

    function fy(y)
        return -(B * y + C) / A
    end

    function rxy(x, y)
        if not segment or within(x, y) then
            table.insert(res, {x=x, y=y})
        end
    end

    local x, y
    if d == 0 then
        -- line is tangent to circle, so just one intersect at most
        if bnz then
            x = -b / (2 * a)
            y = fx(x)
            rxy(x, y)
        else
            y = -b / (2 * a)
            x = fy(y)
            rxy(x, y)
        end
    else
        -- two intersects at most
        d = math.sqrt(d)
        if bnz then
            x = (-b + d) / (2 * a)
            y = fx(x)
            rxy(x, y)
            x = (-b - d) / (2 * a)
            y = fx(x)
            rxy(x, y)
        else
            y = (-b + d) / (2 * a)
            x = fy(y)
            rxy(x, y)
            y = (-b - d) / (2 * a)
            x = fy(y)
            rxy(x, y)
        end
    end

    return res
end

function main()
    print("The intersection points (if any) between:")

    local cp = {x=3, y=-5}
    local r = 3
    print("  A circle, center " .. pts(cp) .. " with radius " .. r .. ", and:")

    local p1 = {x=-10, y=11}
    local p2 = {x=10, y=-9}
    print("    a line containing the points " .. pts(p1) .. " and " .. pts(p2) .. " is/are:")
    print("      " .. lts(intersects(p1, p2, cp, r, false)))

    p2 = {x=-10, y=12}
    print("    a segment starting at " .. pts(p1) .. " and ending at " .. pts(p2) .. " is/are:")
    print("      " .. lts(intersects(p1, p2, cp, r, true)))

    p1 = {x=3, y=-2}
    p2 = {x=7, y=-2}
    print("    a horizontal line containing the points " .. pts(p1) .. " and " .. pts(p2) .. " is/are:")
    print("      " .. lts(intersects(p1, p2, cp, r, false)))

    cp = {x=0, y=0}
    r = 4
    print("  A circle, center " .. pts(cp) .. " with radius " .. r .. ", and:")

    p1 = {x=0, y=-3}
    p2 = {x=0, y=6}
    print("    a vertical line containing the points " .. pts(p1) .. " and " .. pts(p2) .. " is/are:")
    print("      " .. lts(intersects(p1, p2, cp, r, false)))
    print("    a vertical segment starting at " .. pts(p1) .. " and ending at " .. pts(p2) .. " is/are:")
    print("      " .. lts(intersects(p1, p2, cp, r, true)))

    cp = {x=4, y=2}
    r = 5
    print("  A circle, center " .. pts(cp) .. " with radius " .. r .. ", and:")

    p1 = {x=6, y=3}
    p2 = {x=10, y=7}
    print("    a line containing the points " .. pts(p1) .. " and " .. pts(p2) .. " is/are:")
    print("      " .. lts(intersects(p1, p2, cp, r, false)))

    p1 = {x=7, y=4}
    p2 = {x=11, y=8}
    print("    a segment starting at " .. pts(p1) .. " and ending at " .. pts(p2) .. " is/are:")
    print("      " .. lts(intersects(p1, p2, cp, r, true)))
end

main()
