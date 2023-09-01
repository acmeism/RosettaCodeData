function magic (x)
    return x * (1 + x^2) / 2
end

print("Magic constants of orders 3 to 22:")
for i = 3, 22 do
    io.write(magic(i) .. " ")
end

print("\n\nMagic constant 1003: " .. magic(1003) .. "\n")

print("Orders of smallest magic constant greater than...")
print("-----\t-----\nValue\tOrder\n-----\t-----")
local order = 1
for i = 1, 20 do
    repeat
        order = order + 1
    until magic(order) > 10 ^ i
    print("10^" .. i, order)
end
