function sameDigits(n,b)
    local f = n % b
    n = math.floor(n / b)
    while n > 0 do
        if n % b ~= f then
            return false
        end
        n = math.floor(n / b)
    end
    return true
end

function isBrazilian(n)
    if n < 7 then
        return false
    end
    if (n % 2 == 0) and (n >= 8) then
        return true
    end
    for b=2,n-2 do
        if sameDigits(n,b) then
            return true
        end
    end
    return false
end

function isPrime(n)
    if n < 2 then
        return false
    end
    if n % 2 == 0 then
        return n == 2
    end
    if n % 3 == 0 then
        return n == 3
    end

    local d = 5
    while d * d <= n do
        if n % d == 0 then
            return false
        end
        d = d + 2

        if n % d == 0 then
            return false
        end
        d = d + 4
    end

    return true
end

function main()
    local kinds = {" ", " odd ", " prime "}

    for i=1,3 do
        print("First 20" .. kinds[i] .. "Brazillion numbers:")
        local c = 0
        local n = 7
        while true do
            if isBrazilian(n) then
                io.write(n .. " ")
                c = c + 1
                if c == 20 then
                    print()
                    print()
                    break
                end
            end
            if i == 1 then
                n = n + 1
            elseif i == 2 then
                n = n + 2
            elseif i == 3 then
                repeat
                    n = n + 2
                until isPrime(n)
            end
        end
    end
end

main()
