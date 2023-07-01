function print_point(p)
    io.write("("..p.x..", "..p.y..")")
    return nil
end

function print_points(pl)
    io.write("[")
    for i,p in pairs(pl) do
        if i>1 then
            io.write(", ")
        end
        print_point(p)
    end
    io.write("]")
    return nil
end

function ccw(a,b,c)
    return (b.x - a.x) * (c.y - a.y) > (b.y - a.y) * (c.x - a.x)
end

function pop_back(ta)
    table.remove(ta,#ta)
    return ta
end

function convexHull(pl)
    if #pl == 0 then
        return {}
    end
    table.sort(pl, function(left,right)
        return left.x < right.x
    end)

    local h = {}

    -- lower hull
    for i,pt in pairs(pl) do
        while #h >= 2 and not ccw(h[#h-1], h[#h], pt) do
            table.remove(h,#h)
        end
        table.insert(h,pt)
    end

    -- upper hull
    local t = #h + 1
    for i=#pl, 1, -1 do
        local pt = pl[i]
        while #h >= t and not ccw(h[#h-1], h[#h], pt) do
            table.remove(h,#h)
        end
        table.insert(h,pt)
    end

    table.remove(h,#h)
    return h
end

-- main
local points = {
    {x=16,y= 3},{x=12,y=17},{x= 0,y= 6},{x=-4,y=-6},{x=16,y= 6},
    {x=16,y=-7},{x=16,y=-3},{x=17,y=-4},{x= 5,y=19},{x=19,y=-8},
    {x= 3,y=16},{x=12,y=13},{x= 3,y=-4},{x=17,y= 5},{x=-3,y=15},
    {x=-3,y=-9},{x= 0,y=11},{x=-9,y=-3},{x=-4,y=-2},{x=12,y=10}
}
local hull = convexHull(points)

io.write("Convex Hull: ")
print_points(hull)
print()
