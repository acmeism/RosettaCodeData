function fusc(n)
    n = math.floor(n)
    if n == 0 or n == 1 then
        return n
    elseif n % 2 == 0 then
        return fusc(n / 2)
    else
        return fusc((n - 1) / 2) + fusc((n + 1) / 2)
    end
end

function numLen(n)
    local sum = 1
    while n > 9 do
        n = math.floor(n / 10)
        sum = sum + 1
    end
    return sum
end

function printLargeFuscs(limit)
    print("Printing all largest Fusc numbers up to " .. limit)
    print("Index-------Value")
    local maxLen = 1
    for i=0,limit do
        local f = fusc(i)
        local le = numLen(f)
        if le > maxLen then
            maxLen = le
        print(string.format("%5d%12d", i, f))
        end
    end
end

function main()
    print("Index-------Value")
    for i=0,60 do
        print(string.format("%5d%12d", i, fusc(i)))
    end
    printLargeFuscs(math.pow(2, 31) - 1)
end

main()
