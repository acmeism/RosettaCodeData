using Primes

isxbyx(n, base=10, dig=3) = n ÷ prevpow(base, n) == dig && n % base == dig
p3x3(N, base=10, dig=3) = [p for p in primes(N) if isxbyx(p, base, dig)]

for d in 1:2:9
    println("\n$(d)x$d primes < 10000:")
    foreach(p -> print(rpad(last(p), 5), first(p) % 11 == 0 ? "\n" : ""),
        enumerate(p3x3(10000, 10, d)))
    println("\nTotal $(d)x$d primes less than 1,000,000: ", length(p3x3(1_000_000, 10, d)), ".")
end
