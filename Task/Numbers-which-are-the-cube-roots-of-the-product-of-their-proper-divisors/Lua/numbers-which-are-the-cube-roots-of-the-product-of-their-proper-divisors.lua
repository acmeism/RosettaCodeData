function is_1_or_has_eight_divisors (n)
    if n == 1 then return true end
    local divCount, sqr = 2, math.sqrt(n)
    for d = 2, sqr do
        if n % d == 0 then
            divCount = d == sqr and divCount + 1 or divCount + 2
        end
        if divCount > 8 then return false end
    end
    return divCount == 8
end

-- First 50
local count, x = 0, 0
while count < 50 do
    x = x + 1
    if is_1_or_has_eight_divisors(x) then
        io.write(x .. " ")
        count = count + 1
    end
end

-- 500th, 5,000th and 50,000th
while count < 50000 do
    x = x + 1
    if is_1_or_has_eight_divisors(x) then
        count = count + 1
        if count == 500 then print("\n\n500th: " .. x) end
        if count == 5000 then print("5,000th: " .. x) end
    end
end
print("50,000th: " .. x)
