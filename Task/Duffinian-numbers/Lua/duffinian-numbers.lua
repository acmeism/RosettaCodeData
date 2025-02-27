function gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return a
end

function duffinian(n)
    if n == 2 then return false end
    local total = 1
    local power = 2
    local m = n
    while (n & 1) == 0 do
        total = total + power
        power = power << 1
        n = n >> 1
    end
    local p = 3
    while p * p <= n do
        local sum = 1
        local power = p
        while n % p == 0 do
            sum = sum + power
            power = power * p
            n = n / p
        end
        total = total * sum
        p = p + 2
    end
    if m == n then return false end
    if n > 1 then total = total * (n + 1) end
    return gcd(total, m) == 1
end

print("First 50 Duffinian numbers:")
count = 0
n = 1
while count < 50 do
    if duffinian(n) then
        count = count + 1
        if count % 10 == 0 then space = 10 else space = 32 end
        io.write(string.format('%3d%c', n, space))
    end
    n = n + 1
end

print("\nFirst 30 Duffinian triplets:")
n = 1
m = 0
count = 0
while count < 30 do
    if duffinian(n) then m = m + 1 else m = 0 end
    if m == 3 then
        count = count + 1
        print(string.format('%d, %d, %d', n - 2, n - 1, n))
    end
    n = n + 1
end
