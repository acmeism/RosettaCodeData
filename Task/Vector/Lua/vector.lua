vector = {mt = {}}

function vector.new (x, y)
    local new = {x = x or 0, y = y or 0}
    setmetatable(new, vector.mt)
    return new
end

function vector.mt.__add (v1, v2)
    return vector.new(v1.x + v2.x, v1.y + v2.y)
end

function vector.mt.__sub (v1, v2)
    return vector.new(v1.x - v2.x, v1.y - v2.y)
end

function vector.mt.__mul (v, s)
    return vector.new(v.x * s, v.y * s)
end

function vector.mt.__div (v, s)
    return vector.new(v.x / s, v.y / s)
end

function vector.print (vec)
    print("(" .. vec.x .. ", " .. vec.y .. ")")
end

local a, b = vector.new(5, 7), vector.new(2, 3)
vector.print(a + b)
vector.print(a - b)
vector.print(a * 11)
vector.print(a / 2)
