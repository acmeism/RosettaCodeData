function agm(a, b, tolerance)
    if not tolerance or tolerance < 1e-15 then
        tolerance = 1e-15
    end
    repeat
        a, b = (a + b) / 2, math.sqrt(a * b)
    until math.abs(a-b) < tolerance
    return a
end

print(string.format("%.15f", agm(1, 1 / math.sqrt(2))))
