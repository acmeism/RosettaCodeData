function nonSquare (n)
    return n + math.floor(1/2 + math.sqrt(n))
end

for n = 1, 22 do
    io.write(nonSquare(n) .. " ")
end
print()
local sr
for n = 1, 10^6 do
    sr = math.sqrt(nonSquare(n))
    if sr == math.floor(sr) then
        print("Result for n = " .. n .. " is square!")
        os.exit()
    end
end
print("No squares found")
