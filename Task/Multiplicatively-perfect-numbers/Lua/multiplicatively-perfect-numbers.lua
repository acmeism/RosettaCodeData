require "math"

local function isprime(n)
    if n <= 1 then
        return false;
    end

    for i=2,math.sqrt(n) do
        if math.mod(n, i) == 0 then
            return false;
        end
    end

    return true;
end

local function is_mpn(n)
    local first, second = 0, 0
    local delta = 1 + (n % 2)
    local d = delta + 1

    while d * d <= n do
        if n % d == 0 then
            if second ~= 0 then
                return false
            end

            first = d
            local q = math.floor(n / d)

            if q ~= d then
                second = q
            end
        end
        d = d + delta
    end

    return first * second == n
end


local function main()
    local count = 0

    for n = 1, 499 do
        if is_mpn(n) then
            count = count + 1
            io.write(string.format("%3d ", n))

            if count % 10 == 0 then
                print()
            end
        end
    end

    print('\n')

    local mpn_count = 0
    local limit = 500
    local ns, nc = 3, 3
    local squares, cubes = 1, 1
    local n = 1

    while true do
        n = n + 1

        if n == limit then
            while ns * ns < limit do
                if isprime(ns) then
                    squares = squares + 1
                end
                ns = ns + 2
            end

            while nc ^ 3 < limit do
                if isprime(nc) then
                    cubes = cubes + 1
                end
                nc = nc + 2
            end

            print(string.format("Under %d there are %d MPNs and %d semi-primes.", limit, mpn_count, mpn_count - cubes + squares))

            if limit == 500000 then
                break
            end

            limit = limit * 10
        end

        if is_mpn(n) then
            mpn_count = mpn_count + 1
        end
    end
end

main()
