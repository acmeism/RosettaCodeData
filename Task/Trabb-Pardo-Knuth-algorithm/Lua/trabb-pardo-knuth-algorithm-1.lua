function f (x) return math.abs(x)^0.5 + 5*x^3 end

function reverse (t)
    local rev = {}
    for i, v in ipairs(t) do rev[#t - (i-1)] = v end
    return rev
end

local sequence, result = {}
print("Enter 11 numbers...")
for n = 1, 11 do
    io.write(n .. ": ")
    sequence[n] = io.read()
end
for _, x in ipairs(reverse(sequence)) do
    result = f(x)
    if result > 400 then print("Overflow!") else print(result) end
end
