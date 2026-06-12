""" rosettacode.org /wiki/Lantern_Problem """

using Combinatorics

function lanternproblem(verbose = true)
    println("Input number of columns, then column heights in sequence:")
    inputs = [parse(Int, i) for i in split(readline(), r"\s+")]
    n = popfirst!(inputs)
    println("\nThere are ", multinomial(BigInt.(inputs)...), " ways to take these ", n, " columns down.")

    if verbose
        idx, fullmat = 0, zeros(Int, n, maximum(n))
        for col in 1:size(fullmat, 2), row in 1:size(fullmat, 1)
            if inputs[col] >= row
                fullmat[row, col] = (idx += 1)
            end
        end
        show(stdout, "text/plain", map(n -> n > 0 ? "$n " : "  ", fullmat))
        println("\n")
        takedownways = unique(permutations(reduce(vcat, [fill(i, m) for (i, m) in enumerate(inputs)])))
        for way in takedownways
            print("[")
            mat = copy(fullmat)
            for (i, col) in enumerate(way)
                row = findlast(>(0), @view mat[:, col])
                print(mat[row, col], i == length(way) ? "]\n" : ", ")
                mat[row, col] = 0
            end
        end
    end
end

lanternproblem()
lanternproblem()
lanternproblem(false)
