MAX_NUMBER = 20000
sumDivs = {}    -- table of proper divisors
for i = 1, MAX_NUMBER do sumDivs[ i ] = 1 end
for i = 2, MAX_NUMBER do
    for j = i + i, MAX_NUMBER, i do
        sumDivs[ j ] = sumDivs[ j ] + i
    end
end

for n = 2, MAX_NUMBER do
    m = sumDivs[n]
    if m > n then
        if sumDivs[m] == n then print(n, m) end
    end
end
