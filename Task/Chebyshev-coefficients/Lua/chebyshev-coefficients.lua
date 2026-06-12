function map(x, min_x, max_x, min_to, max_to)
    return (x - min_x) / (max_x - min_x) * (max_to - min_to) + min_to
end

function chebyshevCoef(func, minn, maxx, coef)
    local N = #coef
    for j=1,N do
        local i = j - 1
        local m = map(math.cos(math.pi * (i + 0.5) / N), -1, 1, minn, maxx)
        local f = func(m) * 2 / N

        for k=1,N do
            local p = k  -1
            coef[k] = coef[k] + f * math.cos(math.pi * p * (i + 0.5) / N)
        end
    end
end

function main()
    local N = 10
    local c = {}
    local minn = 0.0
    local maxx = 1.0

    for i=1,N do
        table.insert(c, 0)
    end

    chebyshevCoef(function (x) return math.cos(x) end, minn, maxx, c)

    print("Coefficients:")
    for i,d in pairs(c) do
        print(d)
    end
end

main()
