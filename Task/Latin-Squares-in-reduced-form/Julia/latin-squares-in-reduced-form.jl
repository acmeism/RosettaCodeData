using Combinatorics

clash(row2, row1::Vector{Int}) = any(i -> row1[i] == row2[i], 1:length(row2))

clash(row, rows::Vector{Vector{Int}}) = any(r -> clash(row, r), rows)

permute_onefixed(i, n) = map(vec -> vcat(i, vec), permutations(filter(x -> x != i, 1:n)))

filter_permuted(rows, i, n) = filter(v -> !clash(v, rows), permute_onefixed(i, n))

function makereducedlatinsquares(n)
    matarray = [reshape(collect(1:n), 1, n)]
    for i in 2:n
        newmatarray = Vector{Matrix{Int}}()
        for mat in matarray
            r = size(mat)[1] + 1
            newrows = filter_permuted(collect(row[:] for row in eachrow(mat)), r, n)
            newmat = zeros(Int, r, n)
            newmat[1:r-1, :] .= mat
            append!(newmatarray,
                [deepcopy(begin newmat[i, :] .= row; newmat end) for row in newrows])
        end
        matarray = newmatarray
    end
    matarray, length(matarray)
end

function testlatinsquares()
    squares, count = makereducedlatinsquares(4)
    println("The four reduced latin squares of order 4 are:")
    for sq in squares, (i, row) in enumerate(eachrow(sq)), j in 1:4
        print(row[j], j == 4 ? (i == 4 ? "\n\n" : "\n") : " ")
    end
    for i in 1:6
        squares, count = makereducedlatinsquares(i)
        println("Order $i: Size ", rpad(count, 5), "* $(i)! * $(i - 1)! = ",
            count * factorial(i) * factorial(i - 1))
    end
end

testlatinsquares()
