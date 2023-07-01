function leftShift(n,p)
    local r = n
    while p>0 do
        r = r * 2
        p = p - 1
    end
    return r
end

-- main

local MAX_IT = 13
local MAX_IT_J = 10
local a1 = 1.0
local a2 = 0.0
local d1 = 3.2

print(" i       d")
for i=2,MAX_IT do
    local a = a1 + (a1 - a2) / d1
    for j=1,MAX_IT_J do
        local x = 0.0
        local y = 0.0
        for k=1,leftShift(1,i) do
            y = 1.0 - 2.0 * y * x
            x = a - x * x
        end
        a = a - x / y
    end
    d = (a1 - a2) / (a - a1)
    print(string.format("%2d    %.8f", i, d))
    d1 = d
    a2 = a1
    a1 = a
end
