using Primes

divisors(n) = @view sort!(vec(map(prod, Iterators.product((p.^(0:m) for (p, m) in eachfactor(n))...))))[begin:end-1]

issuperPoulet(n) = !isprime(n) && big"2"^(n - 1) % n == 1 && all(d -> (big"2"^d - 2) % d == 0, divisors(n))

spoulets = filter(issuperPoulet, 1:12_000_000)

println("The first 20 super-Poulet numbers are: ", spoulets[1:20])

idx1m = findfirst(>(1_000_000), spoulets)
idx10m = findfirst(>(10_000_000), spoulets)

println("The first super-Poulet number over 1 million is the ", idx1m, "th one, which is ", spoulets[idx1m])
println("The first super-Poulet number over 10 million is the ", idx10m, "th one, which is ", spoulets[idx10m])
