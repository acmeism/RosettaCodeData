function sumDivs (n)
    if n < 2 then return 0 end
    local sum, sr = 1, math.sqrt(n)
    for d = 2, sr do
        if n % d == 0 then
            sum = sum + d
            if d ~= sr then sum = sum + n / d end
        end
    end
    return sum
end

local a, d, p, Pn = 0, 0, 0
for n = 1, 20000 do
    Pn = sumDivs(n)
    if Pn > n then a = a + 1 end
    if Pn < n then d = d + 1 end
    if Pn == n then p = p + 1 end
end
print("Abundant:", a)
print("Deficient:", d)
print("Perfect:", p)
