-- Return length of an integer without string conversion
function numLength (n)
    local length = 0
    repeat
        n = math.floor(n / 10)
        length = length + 1
    until n == 0
    return length
end

-- Return a boolean indicating whether n is a Kaprekar number
function isKaprekar (n)
    if n == 1 then return true end
    local nSquared, a, b = n * n
    for splitPoint = 1, numLength(nSquared) - 1 do
        a = math.floor(nSquared / 10^splitPoint)
        b = nSquared % 10^splitPoint
        if a > 0 and b > 0 and a + b == n then return true end
    end
    return false
end

-- Main task
for n = 1, 10^4 do
    if isKaprekar(n) then io.write(n .. " ") end
end

-- Extra credit
local count = 0
for n = 1, 10^6 do
    if isKaprekar(n) then count = count + 1 end
end
print("\nThere are " .. count .. " Kaprekar numbers under one million.")
