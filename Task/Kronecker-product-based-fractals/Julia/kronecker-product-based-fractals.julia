function matkronpow(M::Matrix, n::Int)
    P = copy(M)
    for i in 1:n P = kron(P, M) end
    return P
end

function fracprint(M::Matrix)
    for i in 1:size(M, 1)
        for j in 1:size(M, 2)
            print(M[i, j] == 1 ? '*' : ' ')
        end
        println()
    end
end

M = [0 1 0; 1 1 1; 0 1 0]
matkronpow(M, 3) |> fracprint

M = [1 1 1; 1 0 1; 1 1 1]
matkronpow(M, 3) |> fracprint
