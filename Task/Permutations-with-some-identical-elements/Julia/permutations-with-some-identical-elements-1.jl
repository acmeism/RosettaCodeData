using Combinatorics

catlist(spec) = mapreduce(i -> repeat([i], spec[i]), vcat, 1:length(spec))

alphastringfromintvector(v) = String([Char(Int('A') + i - 1) for i in v])

function testpermwithident(spec)
    println("\nTesting $spec yielding:")
    for (i, p) in enumerate(unique(collect(permutations(catlist(spec)))))
        print(alphastringfromintvector(p), "  ", i % 10 == 0 ? "\n" : "")
    end
end

testpermwithident([2, 3, 1])
