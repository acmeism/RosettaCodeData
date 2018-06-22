using Primes

ispernicious(n::Integer) = isprime(count_ones(n))
nextpernicious(n::Integer) = begin n += 1; while !ispernicious(n) n += 1 end; return n end
function perniciouses(n::Int)
    rst = Vector{Int}(n)
    rst[1] = 3
    for i in 2:n
        rst[i] = nextpernicious(rst[i-1])
    end
    return rst
end
perniciouses(a::Integer, b::Integer) = filter(ispernicious, a:b)

println("First 25 pernicious numbers: ", join(perniciouses(25), ", "))
println("Perniciouses in [888888877, 888888888]: ", join(perniciouses(888888877, 888888888), ", "))
