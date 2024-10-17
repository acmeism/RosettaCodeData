function Strassen(A, B)
    n = size(A, 1)
    if n == 1
        return A * B
    end
    @views A11 = A[1:n÷2, 1:n÷2]
    @views A12 = A[1:n÷2, n÷2+1:n]
    @views A21 = A[n÷2+1:n, 1:n÷2]
    @views A22 = A[n÷2+1:n, n÷2+1:n]
    @views B11 = B[1:n÷2, 1:n÷2]
    @views B12 = B[1:n÷2, n÷2+1:n]
    @views B21 = B[n÷2+1:n, 1:n÷2]
    @views B22 = B[n÷2+1:n, n÷2+1:n]

    P1 = Strassen(A12 - A22, B21 + B22)
    P2 = Strassen(A11 + A22, B11 + B22)
    P3 = Strassen(A11 - A21, B11 + B12)
    P4 = Strassen(A11 + A12, B22)
    P5 = Strassen(A11, B12 - B22)
    P6 = Strassen(A22, B21 - B11)
    P7 = Strassen(A21 + A22, B11)

    C11 = P1 + P2 - P4 + P6
    C12 = P4 + P5
    C21 = P6 + P7
    C22 = P2 - P3 + P5 - P7

    return [C11 C12; C21 C22]
end

const A = [[1, 2] [3, 4]]
const B = [[5, 6] [7, 8]]
const C = [[1, 1, 1, 1] [2, 4, 8, 16] [3, 9, 27, 81] [4, 16, 64, 256]]
const D = [[4, -3, 4/3, -1/4] [-13/3, 19/4, -7/3, 11/24] [3/2, -2, 7/6, -1/4] [-1/6, 1/4, -1/6, 1/24]]
const E = [[1, 2, 3, 4] [5, 6, 7, 8] [9, 10, 11, 12] [13, 14, 15, 16]]
const F = [[1, 0, 0, 0] [0, 1, 0, 0] [0, 0, 1, 0] [0, 0, 0, 1]]

intprint(s, mat) = println(s, map(x -> Int(round(x, digits=8)), mat)')
intprint("Regular multiply: ", A' * B')
intprint("Strassen multiply: ", Strassen(Matrix(A'), Matrix(B')))
intprint("Regular multiply: ", C * D)
intprint("Strassen multiply: ", Strassen(C, D))
intprint("Regular multiply: ", E * F)
intprint("Strassen multiply: ", Strassen(E, F))

const r = sqrt(2)/2
const R = [[r, r] [-r, r]]

intprint("Regular multiply: ", R * R)
intprint("Strassen multiply: ", Strassen(R,R))
