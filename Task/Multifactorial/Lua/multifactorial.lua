function multiFact (n, degree)
    local fact = 1
    for i = n, 2, -degree do
        fact = fact * i
    end
    return fact
end

print("Degree\t|\tMultifactorials 1 to 10")
print(string.rep("-", 52))
for d = 1, 5 do
    io.write(" " .. d, "\t| ")
    for n = 1, 10 do
        io.write(multiFact(n, d) .. " ")
    end
    print()
end
