function computeGamma (iterations, decimalPlaces)
    local Hn = 1
    for i = 2, iterations do
        Hn = Hn + (1/i)
    end
    local gamma = tostring(Hn - math.log(iterations))
    return tonumber(gamma:sub(1, decimalPlaces + 2))
end

print(computeGamma(10^8, 8))
