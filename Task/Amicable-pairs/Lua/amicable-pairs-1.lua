function sumDivs (n)
    local sum = 1
    for d = 2, math.sqrt(n) do
        if n % d == 0 then
            sum = sum + d
            sum = sum + n / d
        end
    end
    return sum
end

for n = 2, 20000 do
    m = sumDivs(n)
    if m > n then
        if sumDivs(m) == n then print(n, m) end
    end
end
