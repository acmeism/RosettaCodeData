function epsilon()
    local eps = 1.0
    while 1.0 + eps ~= 1.0 do
        eps = eps / 2.0
    end
    return eps
end

function kahanSum(nums)
    local sum = 0.0
    local c = 0.0
    for _,num in ipairs(nums) do
        local y = num - c
        local t = sum + y
        c = (t - sum) - y
        sum = t
    end
    return sum
end

-- main
local a = 1.0
local b = epsilon()
local c = -b
local fa = {a,b,c}

print(string.format("Epsilon     = %0.24f", b))
print(string.format("(a + b) + c = %0.24f", (a+b)+c))
print(string.format("Kahan sum   = %0.24f", kahanSum(fa)))
