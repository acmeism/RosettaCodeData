function factorial (n)
    local f = 1
    for i = 2, n do
        f = f * i
    end
    return f
end

function binomial (n, k)
    if k > n then return 0 end
    return factorial(n) / (factorial(k) * factorial(n - k))
end

function pascalMatrix (form, size)
    local matrix = {}
    for row = 1, size do
        matrix[row] = {}
        for col = 1, size do
            if form == "upper" then
                matrix[row][col] = binomial(col - 1, row - 1)
            end
            if form == "lower" then
                matrix[row][col] = binomial(row - 1, col - 1)
            end
            if form == "symmetric" then
                matrix[row][col] = binomial(row + col - 2, col - 1)
            end
        end
    end
    matrix.form = form:sub(1, 1):upper() .. form:sub(2, -1)
    return matrix
end

function show (mat)
    print(mat.form .. ":")
    for i = 1, #mat do
        for j = 1, #mat[i] do
            io.write(mat[i][j] .. "\t")
        end
        print()
    end
    print()
end

for _, form in pairs({"upper", "lower", "symmetric"}) do
    show(pascalMatrix(form, 5))
end
