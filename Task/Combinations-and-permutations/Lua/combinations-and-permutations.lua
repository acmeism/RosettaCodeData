-- Helper function to display results in scientific notation corrected
function eshow(x)
    local e = math.floor(x / math.log(10))
    local exponentiated = math.exp(x - e * math.log(10))
    -- Corrected format specifier from %.8Fe%+d to %.8e, and manually constructing the scientific notation if needed
    return string.format("%.8e", exponentiated) .. "e" .. tostring(e)
end

-- The rest of the functions remain the same

-- Define the factorial function for permutations
function P(n, k)
    local x = 1
    for i = n - k + 1, n do
        x = x * i
    end
    return x
end

-- Define the function for big permutations using logarithms
function P_big(n, k)
    local x = 0
    for i = n - k + 1, n do
        x = x + math.log(i)
    end
    return eshow(x)
end

-- Define the combinations function
function C(n, k)
    local x = 1
    for i = 1, k do
        x = x * (n - i + 1) / i
    end
    return x
end

-- Define the function for big combinations using logarithms
function C_big(n, k)
    local x = 0
    for i = 1, k do
        x = x + math.log(n - i + 1) - math.log(i)
    end
    return math.exp(x)
end

-- Function to showcase the calculations
function showoff(text, code, fname, ...)
    local n = {...}
    print("\nA sample of " .. text .. " from " .. n[1] .. " to " .. n[#n] .. "")
    for _, v in ipairs(n) do
        local k = math.floor(v / 3)
        print(v, fname .. " " .. k .. " = ", code(v, k))
    end
end

-- Examples of usage
showoff("Permutations", P, "P", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
showoff("Combinations", C, "C", 10, 20, 30, 40, 50, 60)
showoff("Permutations", P_big, "P", 5, 50, 500, 1000, 5000, 15000)
showoff("Combinations", C_big, "C", 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
