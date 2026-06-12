function printNbyN(sizes)
    for N in sizes
        mat = zeros(Int, N, N)
        println("\n\nMinimum number of cells after, before, above and below $N x $N square:")
        for r in 1:N, c in 1:N
             mat[r, c] = min(r - 1, c - 1, N - r, N - c)
        end
        display(mat)
    end
end

printNbyN([23, 10, 9, 2, 1])

