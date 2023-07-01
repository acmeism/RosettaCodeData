function make(n, d)
    local a = {}
    for i=1,n do
        table.insert(a, d)
    end
    return a
end

function reverse(t)
    local n = #t
    local i = 1
    while i < n do
        t[i],t[n] = t[n],t[i]
        i = i + 1
        n = n - 1
    end
end

function tail(list)
    return { select(2, unpack(list)) }
end

function divisors(n)
    local divs = {}
    table.insert(divs, 1)

    local divs2 = {}

    local i = 2
    while i * i <= n do
        if n % i == 0 then
            local j = n / i
            table.insert(divs, i)
            if i ~= j then
                table.insert(divs2, j)
            end
        end
        i = i + 1
    end

    reverse(divs)
    for i,v in pairs(divs) do
        table.insert(divs2, v)
    end
    return divs2
end

function abundant(n, divs)
    local sum = 0
    for i,v in pairs(divs) do
        sum = sum + v
    end
    return sum > n
end

function semiPerfect(n, divs)
    if #divs > 0 then
        local h = divs[1]
        local t = tail(divs)
        if n < h then
            return semiPerfect(n, t)
        else
            return n == h
                or semiPerfect(n - h, t)
                or semiPerfect(n, t)
        end
    else
        return false
    end
end

function sieve(limit)
    -- false denotes abundant and not semi-perfect.
    -- Only interested in even numbers >= 2
    local w = make(limit, false)
    local i = 2
    while i < limit do
        if not w[i] then
            local divs = divisors(i)
            if not abundant(i, divs) then
                w[i] = true
            elseif semiPerfect(i, divs) then
                local j = i
                while j < limit do
                    w[j] = true
                    j = j + i
                end
            end
        end
        i = i + 1
    end
    return w
end

function main()
    local w = sieve(17000)
    local count = 0
    local max = 25
    print("The first 25 weird numbers:")
    local n = 2
    while count < max do
        if not w[n] then
            io.write(n, ' ')
            count = count + 1
        end
        n = n + 2
    end
    print()
end

main()
