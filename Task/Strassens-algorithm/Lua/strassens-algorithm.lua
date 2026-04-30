-- Helper function to create a matrix from nested blocks
local function block_matrix(blocks)
    local m = {}
    local num_hblocks = #blocks
    local num_vblocks = #blocks[1]

    -- Determine dimensions
    local block_height = #blocks[1][1]
    local block_widths = {}
    for j = 1, num_vblocks do
        block_widths[j] = #blocks[1][j][1]
    end

    -- Build the resulting matrix
    for i = 1, block_height * num_hblocks do
        m[i] = {}
    end

    for h = 1, num_hblocks do
        local row_offset = (h - 1) * block_height
        for i = 1, block_height do
            local col_offset = 0
            for v = 1, num_vblocks do
                local block = blocks[h][v]
                for j = 1, block_widths[v] do
                    m[row_offset + i][col_offset + j] = block[i][j]
                end
                col_offset = col_offset + block_widths[v]
            end
        end
    end

    return m
end

-- Matrix multiplication (naive)
local function matrix_multiply(a, b)
    local rows_a, cols_a = #a, #a[1]
    local rows_b, cols_b = #b, #b[1]

    assert(cols_a == rows_b, "Incompatible matrix dimensions for multiplication")

    local result = {}
    for i = 1, rows_a do
        result[i] = {}
        for j = 1, cols_b do
            local sum = 0
            for k = 1, cols_a do
                sum = sum + a[i][k] * b[k][j]
            end
            result[i][j] = sum
        end
    end

    return result
end

-- Matrix addition
local function matrix_add(a, b)
    local rows, cols = #a, #a[1]
    assert(rows == #b and cols == #b[1], "Matrices must have the same dimensions")

    local result = {}
    for i = 1, rows do
        result[i] = {}
        for j = 1, cols do
            result[i][j] = a[i][j] + b[i][j]
        end
    end

    return result
end

-- Matrix subtraction
local function matrix_subtract(a, b)
    local rows, cols = #a, #a[1]
    assert(rows == #b and cols == #b[1], "Matrices must have the same dimensions")

    local result = {}
    for i = 1, rows do
        result[i] = {}
        for j = 1, cols do
            result[i][j] = a[i][j] - b[i][j]
        end
    end

    return result
end

-- Get submatrix
local function get_submatrix(m, start_row, end_row, start_col, end_col)
    local result = {}
    for i = start_row, end_row do
        local row = {}
        for j = start_col, end_col do
            table.insert(row, m[i][j])
        end
        table.insert(result, row)
    end
    return result
end

-- Strassen's algorithm
local function strassen_multiply(a, b)
    local n = #a
    local m = #a[1]

    assert(n == m, "Matrix must be square")
    assert(n == #b and n == #b[1], "Matrices must have the same dimensions")

    -- Check if size is a power of 2
    local temp = n
    while temp > 1 do
        assert(temp % 2 == 0, "Matrix dimension must be a power of 2")
        temp = temp / 2
    end

    if n == 1 then
        return {{a[1][1] * b[1][1]}}
    end

    local half = n // 2

    -- Partition matrices into quadrants
    local a11 = get_submatrix(a, 1, half, 1, half)
    local a12 = get_submatrix(a, 1, half, half+1, n)
    local a21 = get_submatrix(a, half+1, n, 1, half)
    local a22 = get_submatrix(a, half+1, n, half+1, n)

    local b11 = get_submatrix(b, 1, half, 1, half)
    local b12 = get_submatrix(b, 1, half, half+1, n)
    local b21 = get_submatrix(b, half+1, n, 1, half)
    local b22 = get_submatrix(b, half+1, n, half+1, n)

    -- Calculate the seven products
    local m1 = strassen_multiply(matrix_add(a11, a22), matrix_add(b11, b22))
    local m2 = strassen_multiply(matrix_add(a21, a22), b11)
    local m3 = strassen_multiply(a11, matrix_subtract(b12, b22))
    local m4 = strassen_multiply(a22, matrix_subtract(b21, b11))
    local m5 = strassen_multiply(matrix_add(a11, a12), b22)
    local m6 = strassen_multiply(matrix_subtract(a21, a11), matrix_add(b11, b12))
    local m7 = strassen_multiply(matrix_subtract(a12, a22), matrix_add(b21, b22))

    -- Calculate the four quadrants of the result
    local c11 = matrix_add(matrix_subtract(matrix_add(m1, m4), m5), m7)
    local c12 = matrix_add(m3, m5)
    local c21 = matrix_add(m2, m4)
    local c22 = matrix_add(matrix_subtract(matrix_add(m1, m3), m2), m6)

    -- Combine quadrants into a single matrix
    return block_matrix({{c11, c12}, {c21, c22}})
end

-- Round matrix values
local function matrix_round(m, digits)
    local result = {}
    local mult = 10^digits

    for i = 1, #m do
        result[i] = {}
        for j = 1, #m[1] do
            if digits then
                result[i][j] = math.floor(m[i][j] * mult + 0.5) / mult
            else
                result[i][j] = math.floor(m[i][j] + 0.5)
            end
        end
    end

    return result
end

-- Print matrix
local function print_matrix(name, m)
    print(name .. " = {")
    for i = 1, #m do
        io.write("  {")
        for j = 1, #m[1] do
            io.write(m[i][j])
            if j < #m[1] then
                io.write(", ")
            end
        end
        print("}")
    end
    print("}")
end

-- Examples
local function run_examples()
    local a = {
        {1, 2},
        {3, 4}
    }

    local b = {
        {5, 6},
        {7, 8}
    }

    local c = {
        {1, 1, 1, 1},
        {2, 4, 8, 16},
        {3, 9, 27, 81},
        {4, 16, 64, 256}
    }

    local d = {
        {4, -3, 4/3, -1/4},
        {-13/3, 19/4, -7/3, 11/24},
        {3/2, -2, 7/6, -1/4},
        {-1/6, 1/4, -1/6, 1/24}
    }

    local e = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10, 11, 12},
        {13, 14, 15, 16}
    }

    local f = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    }

    print("Naive matrix multiplication:")
    print_matrix("  a * b", matrix_multiply(a, b))
    print_matrix("  c * d", matrix_round(matrix_multiply(c, d), 0))
    print_matrix("  e * f", matrix_multiply(e, f))

    print("\nStrassen's matrix multiplication:")
    print_matrix("  a * b", strassen_multiply(a, b))
    print_matrix("  c * d", matrix_round(strassen_multiply(c, d), 0))
    print_matrix("  e * f", strassen_multiply(e, f))
end

-- Run examples
run_examples()
