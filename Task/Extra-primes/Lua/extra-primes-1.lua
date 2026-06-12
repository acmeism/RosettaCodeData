function next_prime_digit_number(n)
    if n == 0 then
        return 2
    end
    local r = n % 10
    if r == 2 then
        return n + 1
    end
    if r == 3 or r == 5 then
        return n + 2
    end
    return 2 + next_prime_digit_number(math.floor(n / 10)) * 10
end

function is_prime(n)
    if n < 2 then
        return false
    end

    if n % 2 == 0 then
        return n == 2
    end
    if n % 3 == 0 then
        return n == 3
    end
    if n % 5 == 0 then
        return n == 5
    end

    local wheel = { 4, 2, 4, 2, 4, 6, 2, 6 }
    local p = 7
    while true do
        for w = 1, #wheel do
            if p * p > n then
                return true
            end
            if n % p == 0 then
                return false
            end
            p = p + wheel[w]
        end
    end
end

function digit_sum(n)
    local sum = 0
    while n > 0 do
        sum = sum + n % 10
        n = math.floor(n / 10)
    end
    return sum
end

local limit1 = 10000
local limit2 = 1000000000
local last = 10
local p = 0
local n = 0
local extra_primes = {}

print("Extra primes under " .. limit1 .. ":")
while true do
    p = next_prime_digit_number(p)
    if p >= limit2 then
        break
    end
    if is_prime(digit_sum(p)) and is_prime(p) then
        n = n + 1
        if p < limit1 then
            print(string.format("%2d: %d", n, p))
        end
        extra_primes[n % last] = p
    end
end

print(string.format("\nLast %d extra primes under %d:", last, limit2))
local i = last - 1
while i >= 0 do
    print(string.format("%d: %d", n - i, extra_primes[(n - i) % last]))
    i = i - 1
end
