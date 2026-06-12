using Primes

ispseudo(n, base) = !isprime(n) && BigInt(base)^(n - 1) % n == 1

for b in 1:20
    pseudos = filter(n -> ispseudo(n, b), 1:50000)
    println("Base ", lpad(b, 2), " up to 50000: ", lpad(length(pseudos), 5), "  First 20: ", pseudos[1:20])
end
