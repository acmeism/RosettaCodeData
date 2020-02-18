using Printf, Combinatorics

derangements(n::Int) = (perm for perm in permutations(1:n)
                        if all(indx != p for (indx, p) in enumerate(perm)))

function subfact(n::Integer)::Integer
    if n in (0, 2)
        return 1
    elseif n == 1
        return 0
    elseif 1 ≤ n ≤ 18
        return round(Int, factorial(n) / e)
    elseif n > 0
        return (n - 1) * ( subfact(n - 1) + subfact(n - 2) )
    else
        error()
    end
end

println("Derangements of [1, 2, 3, 4]")
for perm in derangements(4)
    println(perm)
end

@printf("\n%5s%13s%13s\n", "n", "derangements", "!n")
for n in 1:10
    ders = derangements(n)
    subf = subfact(n)
    @printf("%5i%13i%13i\n", n, length(collect(ders)), subf)
end

println("\n!20 = ", subfact(20))
