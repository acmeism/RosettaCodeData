function divisorCount(n)
    local total = 1
    -- Deal with powers of 2 first
    while (n & 1) == 0 do
        total = total + 1
        n = math.floor(n / 2)
    end
    -- Odd prime factors up tot eh square root
    local p = 3
    while p * p <= n do
        local count = 1
        while n % p == 0 do
            count = count + 1
            n = n / p
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

limit = 100
print("Count of divisors for the first " .. limit .. " positive integers:")
for n=1,limit do
    io.write(string.format("%3d", divisorCount(n)))
    if n % 20 == 0 then
        print()
    end
end
