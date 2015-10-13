tests = {[1, 2, 3],
         primes(10),
         0:2:6,
         [-Inf, 0.0, Inf],
         [π, e, φ, catalan],
         [2015, 5],
         [-sqrt(50.0), 50.0^2],
         }

println("Testing islexfirst:")
for (a, b) in combinations(tests, 2)
    tres = islexfirst(a, b) ? " is " : " is not "
    tres *= "lexically prior to\n    "
    println("\n    ", a, tres, b)
end
