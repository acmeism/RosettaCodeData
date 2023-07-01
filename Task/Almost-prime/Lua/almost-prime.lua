-- Returns boolean indicating whether n is k-almost prime
function almostPrime (n, k)
    local divisor, count = 2, 0
    while count < k + 1 and n ~= 1 do
        if n % divisor == 0 then
            n = n / divisor
            count = count + 1
        else
            divisor = divisor + 1
        end
    end
    return count == k
end

-- Generates table containing first ten k-almost primes for given k
function kList (k)
    local n, kTab = 2^k, {}
    while #kTab < 10 do
        if almostPrime(n, k) then
            table.insert(kTab, n)
        end
        n = n + 1
    end
    return kTab
end

-- Main procedure, displays results from five calls to kList()
for k = 1, 5 do
    io.write("k=" .. k .. ": ")
    for _, v in pairs(kList(k)) do
        io.write(v .. ", ")
    end
    print("...")
end
