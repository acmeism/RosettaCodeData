function isPrime (n)
    if n < 2 then return false end
    if n < 4 then return true end
    if n % 2 == 0 then return false end
    for d = 3, math.sqrt(n), 2 do
        if n % d == 0 then return false end
    end
    return true
end

function isEmirp (n)
    if not isPrime(n) then return false end
    local rev = tonumber(string.reverse(n))
    if rev == n then return false end
    return isPrime(rev)
end

function emirpGen (mode, a, b)
    local count, n, eString = 0, 0, ""
    if mode == "between" then
        for n = a, b do
            if isEmirp(n) then eString = eString .. n .. " " end
        end
        return eString
    end
    while count < a do
        n = n + 1
        if isEmirp(n) then
            eString = eString .. n .. " "
            count = count + 1
        end
    end
    if mode == "first" then return eString end
    if mode == "Nth" then return n end
end

if #arg > 1 and #arg < 4 then
    print(emirpGen(arg[1], tonumber(arg[2]), tonumber(arg[3])))
else
    print("Wrong number of arguments")
end
