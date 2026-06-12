using Combinatorics, Primes

function primedigitsums(targetsum)

    possibles = mapreduce(x -> fill(x, div(targetsum, x)), vcat, [2, 3, 5, 7])

    a = map(x -> evalpoly(BigInt(10), x),
        mapreduce(x -> unique(collect(permutations(x))), vcat,
        unique(filter(x -> sum(x) == targetsum, collect(combinations(possibles))))))

    println("There are $(length(a)) prime-digit-only numbers summing to $targetsum : $a")

end

foreach(primedigitsums, [5, 7, 11, 13])

function primedigitcombos(targetsum)
    possibles = [2, 3, 5, 7]
    found = Vector{Vector{Int}}()
    combos = [Int[]]
    tempcombos = Vector{Vector{Int}}()
    newcombos = Vector{Vector{Int}}()
    while !isempty(combos)
        for combo in combos, j in possibles
            csum = sum(combo) + j
            if csum <= targetsum
                newcombo = sort!([combo; j])
                csum < targetsum && !(newcombo in newcombos) && push!(newcombos, newcombo)
                csum == targetsum && !(newcombo in found) && push!(found, newcombo)
            end
        end
        empty!(combos)
        tempcombos = combos
        combos = newcombos
        newcombos = tempcombos
    end
    return found
end

function countprimedigitsums(targetsum)
    found = primedigitcombos(targetsum)
    total = sum(arr -> factorial(BigInt(length(arr))) ÷
        prod(x -> factorial(BigInt(count(y -> y == x, arr))), unique(arr)), found)
    println("There are $total prime-digit-only numbers summing to $targetsum.")
end

foreach(countprimedigitsums, nextprimes(17, 40))
