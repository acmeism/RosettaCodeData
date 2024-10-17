using Formatting, Primes, UnicodePlots

radical(n) = prod(map(first, factor(n).pe))
radicallength(n) = length(factor(n).pe)

println("The radicals for the first 50 positive integers are:")
foreach(p -> print(rpad(p[2], 4), p[1] % 10 == 0 ? "\n" : ""), enumerate(map(radical, 1:50)))

for i in [99999, 499999, 999999]
    println("\nRadical for ", format(i, commas=true), ": ", format(radical(i), commas=true))
end

println("\nBreakdown of numbers of distinct prime factors for positive integers from 1 to 1,000,000:")
histogram(map(radicallength, 1:1_000_000), nbins = 8)

println("\nCheck on breakdown:")
primecount = length(primes(1_000_000)) # count of primes to 1 million
powerscount = mapreduce(p -> Int(floor(6 / log10(p)) - 1), +, primes(1000))
println("Prime count to 1 million:          ", lpad(primecount, 6))
println("Prime powers less than 1 million:  ", lpad(powerscount, 6))
println("Subtotal:", lpad(primecount + powerscount, 32))
println("The integer 1 has 0 prime factors: ", lpad(1, 6))
println("-"^41, "\n", "Overall total:", lpad(primecount + powerscount + 1, 27))
