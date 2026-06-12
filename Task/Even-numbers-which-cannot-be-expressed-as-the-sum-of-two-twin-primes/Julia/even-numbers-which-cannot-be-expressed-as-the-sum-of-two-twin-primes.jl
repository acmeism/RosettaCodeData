using Primes

""" Even numbers which cannot be expressed as the sum of two twin primes """
function nonpairsums(;include1=false, limit=20_000)
    tpri = primesmask(limit + 2)
    for i in 1:limit
        tpri[i] && (i > 2 && !tpri[i - 2]) && !tpri[i + 2] && (tpri[i] = false)
    end
    tpri[2] = false
    include1 && (tpri[1] = true)
    twinsums = falses(limit * 2)
    for i in 1:limit-2, j in 1:limit-2
        if tpri[i] && tpri[j]
            twinsums[i + j] = true
        end
    end
    return [i for i in 2:2:limit if !twinsums[i]]
end

println("Non twin prime sums:")
foreach(p -> print(lpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""), pairs(nonpairsums()))

println("\n\nNon twin prime sums (including 1):")
foreach(p -> print(lpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""), pairs(nonpairsums(include1 = true)))
