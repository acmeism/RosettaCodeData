-- Take decimal number, return binary string
function dec2bin (n)
    local bin, bit = ""
    while n > 0 do
        bit = n % 2
        n = math.floor(n / 2)
        bin = bit .. bin
    end
    return bin
end

-- Take decimal number, return population count as number
function popCount (n)
    local bin, count = dec2bin(n), 0
    for pos = 1, bin:len() do
        if bin:sub(pos, pos) == "1" then count = count + 1 end
    end
    return count
end

-- Implement task requirements
function firstThirty (mode)
    local numStr, count, n, remainder = "", 0, 0
    if mode == "Evil" then remainder = 0 else remainder = 1 end
    while count < 30 do
        if mode == "3^x" then
            numStr = numStr .. popCount(3 ^ count) .. " "
            count = count + 1
        else
            if popCount(n) % 2 == remainder then
                numStr = numStr .. n .. " "
                count = count + 1
            end
            n = n + 1
        end
    end
    print(mode .. ":" , numStr)
end

-- Main procedure
firstThirty("3^x")
firstThirty("Evil")
firstThirty("Odious")
