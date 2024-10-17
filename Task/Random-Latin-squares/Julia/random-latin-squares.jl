using Random

shufflerows(mat) = mat[shuffle(1:end), :]
shufflecols(mat) = mat[:, shuffle(1:end)]

function addatdiagonal(mat)
    n = size(mat)[1] + 1
    newmat = similar(mat, size(mat) .+ 1)
    for j in 1:n, i in 1:n
        newmat[i, j] = (i == n && j < n) ? mat[1, j] : (i == j) ? n - 1 :
            (i < j) ? mat[i, j - 1] : mat[i, j]
    end
    newmat
end

function makelatinsquare(N)
    mat = [0 1; 1 0]
    for i in 3:N
        mat = addatdiagonal(mat)
    end
    shufflecols(shufflerows(mat))
end

function printlatinsquare(N)
    mat = makelatinsquare(N)
    for i in 1:N, j in 1:N
        print(rpad(mat[i, j], 3), j == N ? "\n" : "")
    end
end

printlatinsquare(5), println("\n"), printlatinsquare(5)
