function divisor_count(n)
    local total = 1

    -- Deal with powers of 2 first
    while (n & 1) == 0 do
        total = total + 1
        n = n >> 1
    end
    -- Odd prime factors up to the square root
    local p = 3
    while p * p <= n do
        local count = 1
        while n % p == 0 do
            count = count + 1
            n = math.floor(n / p)
        end
        total = total * count
        p = p + 2
    end
    -- If n > 1 then it's prime
    if n > 1 then
        total = total * 2
    end
    return total
end

local limit = 100
local count = 0
print("The first " .. limit .. " tau numbers are:")
local n = 1
while count < limit do
    if n % divisor_count(n) == 0 then
        io.write(string.format("%6d", n))
        count = count + 1
        if count % 10 == 0 then
            print()
        end
    end
    n = n + 1
end
