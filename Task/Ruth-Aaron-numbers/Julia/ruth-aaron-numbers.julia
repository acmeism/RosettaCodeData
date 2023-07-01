using Lazy
using Primes

sumprimedivisors(n) = sum([p[1] for p in factor(n)])
ruthaaron(n) = sumprimedivisors(n) == sumprimedivisors(n + 1)
ruthaarontriple(n) = sumprimedivisors(n) == sumprimedivisors(n + 1) ==
   sumprimedivisors(n + 2)

sumprimefactors(n) = sum([p[1] * p[2] for p in factor(n)])
ruthaaronfactors(n) = sumprimefactors(n) == sumprimefactors(n + 1)
ruthaaronfactorstriple(n) = sumprimefactors(n) == sumprimefactors(n + 1) ==
   sumprimefactors(n + 2)

raseq = @>> Lazy.range() filter(ruthaaron)
rafseq = @>> Lazy.range() filter(ruthaaronfactors)

println("30 Ruth Aaron numbers:")
foreach(p -> print(lpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""),
   enumerate(collect(take(30, raseq))))

println("\n30 Ruth Aaron factor numbers:")
foreach(p -> print(lpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""),
   enumerate(collect(take(30, rafseq))))

println("\nRuth Aaron triple starts at: ", findfirst(ruthaarontriple, 1:100000000))
println("\nRuth Aaron factor triple starts at: ", findfirst(ruthaaronfactorstriple, 1:10000000))
