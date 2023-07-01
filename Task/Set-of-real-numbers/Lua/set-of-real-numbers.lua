function createSet(low,high,rt)
    local l,h = tonumber(low), tonumber(high)
    if l and h then
        local t = {low=l, high=h}

        if type(rt) == "string" then
            if rt == "open" then
                t.contains = function(d) return low< d and d< high end
            elseif rt == "closed" then
                t.contains = function(d) return low<=d and d<=high end
            elseif rt == "left" then
                t.contains = function(d) return low< d and d<=high end
            elseif rt == "right" then
                t.contains = function(d) return low<=d and d< high end
            else
                error("Unknown range type: "..rt)
            end
        elseif type(rt) == "function" then
            t.contains = rt
        else
            error("Unable to find a range type or predicate")
        end

        t.union = function(o)
            local l2 = math.min(l, o.low)
            local h2 = math.min(h, o.high)
            local p = function(d) return t.contains(d) or o.contains(d) end
            return createSet(l2, h2, p)
        end

        t.intersect = function(o)
            local l2 = math.min(l, o.low)
            local h2 = math.min(h, o.high)
            local p = function(d) return t.contains(d) and o.contains(d) end
            return createSet(l2, h2, p)
        end

        t.subtract = function(o)
            local l2 = math.min(l, o.low)
            local h2 = math.min(h, o.high)
            local p = function(d) return t.contains(d) and not o.contains(d) end
            return createSet(l2, h2, p)
        end

        t.length = function()
            if h <= l then return 0.0 end
            local p = l
            local count = 0
            local interval = 0.00001
            repeat
                if t.contains(p) then count = count + 1 end
                p = p + interval
            until p>=high
            return count * interval
        end

        t.empty = function()
            if l == h then
                return not t.contains(low)
            end
            return t.length() == 0.0
        end

        return t
    else
        error("Either '"..low.."' or '"..high.."' is not a number")
    end
end

local a = createSet(0.0, 1.0, "left")
local b = createSet(0.0, 2.0, "right")
local c = createSet(1.0, 2.0, "left")
local d = createSet(0.0, 3.0, "right")
local e = createSet(0.0, 1.0, "open")
local f = createSet(0.0, 1.0, "closed")
local g = createSet(0.0, 0.0, "closed")

for i=0,2 do
    print("(0, 1]   union   [0, 2) contains "..i.." is "..tostring(a.union(b).contains(i)))
    print("[0, 2) intersect (1, 2] contains "..i.." is "..tostring(b.intersect(c).contains(i)))
    print("[0, 3)     -     (0, 1) contains "..i.." is "..tostring(d.subtract(e).contains(i)))
    print("[0, 3)     -     [0, 1] contains "..i.." is "..tostring(d.subtract(f).contains(i)))
    print()
end

print("[0, 0] is empty is "..tostring(g.empty()))
print()

local aa = createSet(
    0.0, 10.0,
    function(x) return (0.0<x and x<10.0) and math.abs(math.sin(math.pi * x * x)) > 0.5 end
)
local bb = createSet(
    0.0, 10.0,
    function(x) return (0.0<x and x<10.0) and math.abs(math.sin(math.pi * x)) > 0.5 end
)
local cc = aa.subtract(bb)
print("Approx length of A - B is "..cc.length())
