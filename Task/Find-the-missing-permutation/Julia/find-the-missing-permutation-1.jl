using BenchmarkTools, Combinatorics

function missingperm(arr::Vector)
    allperms = String.(permutations(arr[1]))  # revised for type safety
    for perm in allperms
        if perm ∉ arr return perm end
    end
end

arr = ["ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD", "ADCB", "CDAB", "DABC", "BCAD",
       "CADB", "CDBA", "CBAD", "ABDC", "ADBC", "BDCA", "DCBA", "BACD", "BADC", "BDAC",
       "CBDA", "DBCA", "DCAB"]
@show missingperm(arr)
