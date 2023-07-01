function chowla(n)
    local sum = 0
    local i = 2
    local j = 0
    while i * i <= n do
        if n % i == 0 then
            j = math.floor(n / i)
            sum = sum + i
            if i ~= j then
                sum = sum + j
            end
        end
        i = i + 1
    end
    return sum
end

function sieve(limit)
    -- True denotes composite, false denotes prime.
    -- Only interested in odd numbers >= 3
    local c = {}
    local i = 3
    while i * 3 < limit do
        if not c[i] and (chowla(i) == 0) then
            local j = 3 * i
            while j < limit do
                c[j] = true
                j = j + 2 * i
            end
        end
        i = i + 2
    end
    return c
end

function main()
    for i = 1, 37 do
        print(string.format("chowla(%d) = %d", i, chowla(i)))
    end
    local count = 1
    local limit = math.floor(1e7)
    local power = 100
    local c = sieve(limit)
    local i = 3
    while i < limit do
        if not c[i] then
            count = count + 1
        end
        if i == power - 1 then
            print(string.format("Count of primes up to %10d = %d", power, count))
            power = power * 10
        end
        i = i + 2
    end

    count = 0
    limit = 350000000
    local k = 2
    local kk = 3
    local p = 0
    i = 2
    while true do
        p = k * kk
        if p > limit then
            break
        end
        if chowla(p) == p - 1 then
            print(string.format("%10d is a number that is perfect", p))
            count = count + 1
        end
        k = kk + 1
        kk = kk + k
        i = i + 1
    end
    print(string.format("There are %d perfect numbers <= 35,000,000", count))
end

main()
