-- Function to have roots found
function f (x) return x^3 - 3*x^2 + 2*x end

-- Find roots of f within x=[start, stop] or approximations thereof
function root (f, start, stop, step)
    local roots, x, sign, foundExact, value = {}, start, f(start) > 0
    while x <= stop do
        value = f(x)
        if value == 0 then
            table.insert(roots, {val = x, err = 0})
            foundExact = true
        end
        if value > 0 ~= sign then
            if foundExact then
                foundExact = false
            else
                table.insert(roots, {val = x, err = step})
            end
        end
        sign = value > 0
        x = x + step
    end
    return roots
end

-- Main procedure
print("Root (to 12DP)\tMax. Error\n")
for _, r in pairs(root(f, -1, 3, 10^-6)) do
    print(string.format("%0.12f", r.val), r.err)
end
