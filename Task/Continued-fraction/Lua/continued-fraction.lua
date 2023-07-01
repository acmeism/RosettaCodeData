function calc(fa, fb, expansions)
    local a = 0.0
    local b = 0.0
    local r = 0.0
    local i = expansions
    while i > 0 do
        a = fa(i)
        b = fb(i)
        r = b / (a + r)
        i = i - 1
    end
    a = fa(0)
    return a + r
end

function sqrt2a(n)
    if n ~= 0 then
        return 2.0
    else
        return 1.0
    end
end

function sqrt2b(n)
    return 1.0
end

function napiera(n)
    if n ~= 0 then
        return n
    else
        return 2.0
    end
end

function napierb(n)
    if n > 1.0 then
        return n - 1.0
    else
        return 1.0
    end
end

function pia(n)
    if n ~= 0 then
        return 6.0
    else
        return 3.0
    end
end

function pib(n)
    local c = 2.0 * n - 1.0
    return c * c
end

function main()
    local sqrt2  = calc(sqrt2a,  sqrt2b,  1000)
    local napier = calc(napiera, napierb, 1000)
    local pi     = calc(pia,     pib,     1000)
    print(sqrt2)
    print(napier)
    print(pi)
end

main()
