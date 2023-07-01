-- Return boolean indicating whether or not n is prime
function isPrime (n)
    if n <= 1 then return false end
    if n <= 3 then return true end
    if n % 2 == 0 or n % 3 == 0 then return false end
    local i = 5
    while i * i <= n do
        if n % i == 0 or n % (i + 2) == 0 then return false end
        i = i + 6
    end
    return true
end

-- Return table of frequencies for final digits of consecutive primes
function primeCon (limit)
    local count, x, last, ending = 2, 3, 3
    local freqList = {
        [1] = {},
        [2] = {[3] = 1},
        [3] = {},
        [5] = {},
        [7] = {},
        [9] = {}
    }
    repeat
        x = x + 2
        if isPrime(x) then
            ending = x % 10
            if freqList[last][ending] then
                freqList[last][ending] = freqList[last][ending] + 1
            else
                freqList[last][ending] = 1
            end
            last = ending
            count = count + 1
        end
    until count == limit
    return freqList
end

-- Main procedure
local limit = 10^6
local t = primeCon(limit)
for a = 1, 9 do
    for b = 1, 9 do
        if t[a] and t[a][b] then
            io.write(a .. " -> " .. b .. "\tcount: " .. t[a][b])
            print("\tfrequency: " .. t[a][b] / limit * 100 .. " %")
        end
    end
end
