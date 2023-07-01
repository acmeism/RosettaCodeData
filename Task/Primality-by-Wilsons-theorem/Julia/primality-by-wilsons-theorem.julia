iswilsonprime(p) = (p < 2 || (p > 2 && iseven(p))) ? false : foldr((x, y) -> (x * y) % p, 1:p - 1) == p - 1

wilsonprimesbetween(n, m) = [i for i in n:m if iswilsonprime(i)]

println("First 120 Wilson primes: ", wilsonprimesbetween(1, 1000)[1:120])
println("\nThe first 40 Wilson primes above 7900 are: ", wilsonprimesbetween(7900, 9000)[1:40])
