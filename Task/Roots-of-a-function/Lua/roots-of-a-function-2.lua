-- Main procedure
print("Root (to 12DP)\tMax. Error\n")
for _, r in pairs(root(f, -1, 3, 2^-10)) do
    print(string.format("%0.12f", r.val), r.err)
end
