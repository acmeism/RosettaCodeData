using Primes

D(n) = n < 0 ? -D(-n) : n < 2 ? zero(n) : isprime(n) ? one(n) : typeof(n)(sum(e * n ÷ p for (p, e) in eachfactor(n)))

foreach(p -> print(lpad(p[2], 5), p[1] % 10 == 0 ? "\n" : ""), pairs(map(D, -99:100)))

println()
for m in 1:20
    println("D for 10^", rpad(m, 3), "divided by 7 is ", D(Int128(10)^m) ÷ 7)
end
