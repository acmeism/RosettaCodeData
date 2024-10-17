using Primes

const dig = zeros(Int, 10)
const primes10B = primes(10_000_000_000)
const sort10B = map(n -> evalpoly(10, sort!(digits!(dig, n))), primes10B)

const ormiston_indices = filter(i -> sort10B[i] == sort10B[i + 1] == sort10B[i + 2],
   firstindex(sort10B):lastindex(sort10B) - 2)

println("First 25 Ormiston triples:")
for i in 1:25
    println(primes10B[ormiston_indices[i]:ormiston_indices[i]+2])
end
println("\nOrmiston triples before 1 billion: ",
    count(t -> primes10B[t] < 1_000_000_000, ormiston_indices))
println("Ormiston triples before 10 billion: ", length(ormiston_indices))
