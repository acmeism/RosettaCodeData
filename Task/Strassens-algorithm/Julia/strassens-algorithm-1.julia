"""
Strassen's matrix multiplication algorithm.
Use dynamic padding in order to reduce required auxiliary memory.
"""
function strassen(x::Matrix, y::Matrix)
    # Check that the sizes of these matrices match.
    (r1, c1) = size(x)
    (r2, c2) = size(y)
    if c1 != r2
        error("Multiplying $r1 x $c1 and $r2 x $c2 matrix: dimensions do not match.")
    end

    # Put a matrix into the top left of a matrix of zeros.
    # `rows` and `cols` are the dimensions of the output matrix.
    function embed(mat, rows, cols)
        # If the matrix is already of the right dimensions, don't allocate new memory.
        (r, c) = size(mat)
        if (r, c) == (rows, cols)
            return mat
        end

        # Pad the matrix with zeros to be the right size.
        out = zeros(Int, rows, cols)
        out[1:r, 1:c] = mat
        out
    end

    # Make sure both matrices are the same size.
    # This is exclusively for simplicity:
    # this algorithm can be implemented with matrices of different sizes.
    r = max(r1, r2); c = max(c1, c2)
    x = embed(x, r, c)
    y = embed(y, r, c)

    # Our recursive multiplication function.
    function block_mult(a, b, rows, cols)
        # For small matrices, resort to naive multiplication.
#       if rows <= 128 || cols <= 128
        if rows == 1 && cols == 1
#       if rows == 2 && cols == 2
            return a * b
        end

        # Apply dynamic padding.
        if rows % 2 == 1 && cols % 2 == 1
            a = embed(a, rows + 1, cols + 1)
            b = embed(b, rows + 1, cols + 1)
        elseif rows % 2 == 1
            a = embed(a, rows + 1, cols)
            b = embed(b, rows + 1, cols)
        elseif cols % 2 == 1
            a = embed(a, rows, cols + 1)
            b = embed(b, rows, cols + 1)
        end

        half_rows = Int(size(a, 1) / 2)
        half_cols = Int(size(a, 2) / 2)

        # Subdivide input matrices.
        a11 = a[1:half_rows, 1:half_cols]
        b11 = b[1:half_rows, 1:half_cols]

        a12 = a[1:half_rows, half_cols+1:size(a, 2)]
        b12 = b[1:half_rows, half_cols+1:size(a, 2)]

        a21 = a[half_rows+1:size(a, 1), 1:half_cols]
        b21 = b[half_rows+1:size(a, 1), 1:half_cols]

        a22 = a[half_rows+1:size(a, 1), half_cols+1:size(a, 2)]
        b22 = b[half_rows+1:size(a, 1), half_cols+1:size(a, 2)]

        # Compute intermediate values.
        multip(x, y) = block_mult(x, y, half_rows, half_cols)
        m1 = multip(a11 + a22, b11 + b22)
        m2 = multip(a21 + a22, b11)
        m3 = multip(a11, b12 - b22)
        m4 = multip(a22, b21 - b11)
        m5 = multip(a11 + a12, b22)
        m6 = multip(a21 - a11, b11 + b12)
        m7 = multip(a12 - a22, b21 + b22)

        # Combine intermediate values into the output.
        c11 = m1 + m4 - m5 + m7
        c12 = m3 + m5
        c21 = m2 + m4
        c22 = m1 - m2 + m3 + m6

        # Crop output to the desired size (undo dynamic padding).
        out = [c11 c12; c21 c22]
        out[1:rows, 1:cols]
    end

    block_mult(x, y, r, c)
end

const A = [[1, 2] [3, 4]]
const B = [[5, 6] [7, 8]]
const C = [[1, 1, 1, 1] [2, 4, 8, 16] [3, 9, 27, 81] [4, 16, 64, 256]]
const D = [[4, -3, 4/3, -1/4] [-13/3, 19/4, -7/3, 11/24] [3/2, -2, 7/6, -1/4] [-1/6, 1/4, -1/6, 1/24]]
const E = [[1, 2, 3, 4] [5, 6, 7, 8] [9, 10, 11, 12] [13, 14, 15, 16]]
const F = [[1, 0, 0, 0] [0, 1, 0, 0] [0, 0, 1, 0] [0, 0, 0, 1]]

""" For pretty printing: change matrix to integer if it is within 0.00000001 of an integer """
intprint(s, mat) = println(s, map(x -> Int(round(x, digits=8)), mat)')

intprint("Regular multiply: ", A' * B')
intprint("Strassen multiply: ", strassen(Matrix(A'), Matrix(B')))
intprint("Regular multiply: ", C * D)
intprint("Strassen multiply: ", strassen(C, D))
intprint("Regular multiply: ", E * F)
intprint("Strassen multiply: ", strassen(E, F))

const r = sqrt(2)/2
const R = [[r, r] [-r, r]]

intprint("Regular multiply: ", R * R)
intprint("Strassen multiply: ", strassen(R,R))
