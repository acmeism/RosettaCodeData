using Primes

println(nextprime.(maximum(hcat([5,45,23,21,67], [43,22,78,46,38], [9,98,12,54,53]), dims=2)))
